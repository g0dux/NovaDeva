# Arquitetura Godot — Contrato entre Módulos

> **Este é o documento-mestre técnico.** Qualquer equipe construindo um módulo isolado só precisa respeitar o que está aqui para que tudo se integre depois.

## Versão e configuração da engine

- **Godot 4.x** (fixar minor version no início da produção, ex.: 4.3).
- Renderer: **Forward+** (PC alvo).
- Física: **Jolt Physics** (built-in a partir do 4.4; extensão antes disso).
- Linguagem: **GDScript** com `static typing` obrigatório (`--warnings-as-errors` para tipos). C# apenas se um sistema exigir performance comprovada por profiling.

## Estrutura de pastas do projeto

```
res://
├── autoload/            # Singletons globais (ver abaixo)
├── data/                # Resources .tres — TODO dado de design vive aqui
│   ├── items/
│   ├── enemies/
│   ├── skills/
│   ├── spells/
│   ├── quests/
│   └── loot_tables/
├── systems/             # Um subdiretório por sistema, AUTOCONTIDO
│   ├── combat/
│   ├── survival/
│   ├── magic/
│   ├── inventory/
│   ├── ai/
│   ├── world/
│   ├── quest/
│   └── save/
├── entities/            # Cenas de entidades (player, inimigos, NPCs)
│   ├── player/
│   ├── enemies/
│   └── npcs/
├── art/                 # Assets importados (ver pipeline de arte)
│   ├── characters/
│   ├── environment/
│   ├── props/
│   ├── vfx/
│   └── materials/
├── audio/
│   ├── music/
│   ├── sfx/
│   └── ambience/
├── levels/              # Cenas de mundo/regiões
├── ui/
└── tests/               # Cenas de teste por sistema (gym scenes)
```

**Regra:** `systems/combat/` nunca faz `preload("res://systems/inventory/...")`. Comunicação só via autoloads e sinais.

## Autoloads (Singletons)

| Autoload | Responsabilidade | Dono |
|---|---|---|
| `EventBus` | Sinais globais tipados — única ponte entre sistemas | Arquitetura |
| `GameState` | Estado da sessão: referência ao player, região atual, tempo do mundo, flags | Arquitetura |
| `SaveManager` | Serialização/desserialização (ver doc 09) | Sistema Save |
| `AudioManager` | Música adaptativa, buses, pooling de SFX | Áudio |
| `WorldClock` | Ciclo dia/noite, calendário, timers de quest | Sistema Mundo |
| `DataRegistry` | Índice de todos os Resources em `data/` por ID | Arquitetura |

### EventBus — sinais principais (contrato v1)

```gdscript
# autoload/event_bus.gd
extends Node

# Combate
signal damage_dealt(attacker: Node, target: Node, result: DamageResult)
signal entity_died(entity: Node, killer: Node)
signal player_defeated(context: DefeatContext)   # NÃO é morte — dispara cenário de derrota
signal boss_fight_started(boss_id: StringName)
signal boss_fight_ended(boss_id: StringName, victory: bool)

# Sobrevivência
signal need_changed(need: StringName, value: float, max_value: float) # "hunger","thirst","sleep","temp"
signal status_effect_applied(target: Node, effect_id: StringName)
signal status_effect_removed(target: Node, effect_id: StringName)

# Inventário
signal item_added(item_id: StringName, amount: int)
signal item_removed(item_id: StringName, amount: int)
signal equipment_changed(slot: StringName, item_id: StringName)
signal weight_class_changed(new_class: StringName)  # "light","medium","heavy"

# Mundo
signal region_entered(region_id: StringName)
signal time_of_day_changed(phase: StringName)       # "dawn","day","dusk","night"
signal weather_changed(weather_id: StringName)
signal world_event_triggered(event_id: StringName)  # ex.: "cacada_palida"

# Quests
signal quest_started(quest_id: StringName)
signal quest_objective_completed(quest_id: StringName, objective_id: StringName)
signal quest_completed(quest_id: StringName, outcome: StringName)
signal quest_expired(quest_id: StringName)          # quests com tempo-limite

# Magia
signal spell_cast(caster: Node, spell_id: StringName)
signal ritual_completed(ritual_id: StringName, position: Vector3)
```

Sistemas **emitem** e **escutam** o EventBus; nunca chamam métodos uns dos outros.

## Dados como Resources

Todo dado de design é um `Resource` custom com `class_name`, salvo como `.tres`:

```gdscript
# systems/inventory/item_data.gd
class_name ItemData extends Resource
@export var id: StringName
@export var display_name: String
@export_multiline var lore_text: String
@export var weight: float = 1.0
@export var stack_size: int = 1
@export var tags: Array[StringName] = []   # "food","weapon","ritual_component"...
```

`DataRegistry` escaneia `res://data/` no boot e expõe `get_item(id)`, `get_enemy(id)` etc. **IDs são `StringName` em snake_case** e nunca mudam depois de criados (são chave de save).

## Cena do Player — composição por componentes

O player é uma cena composta; cada sistema contribui com um **component node** que só conversa com o EventBus e com nodes irmãos via exports:

```
Player (CharacterBody3D)
├── MovementComponent          # física de movimento (doc 04-fisica)
├── CombatComponent            # ataques, defesa, stamina (doc 01)
├── SurvivalComponent          # fome/sede/sono/temperatura (doc 02)
├── InventoryComponent         # mochila, equipamento (doc 05)
├── SpellcastComponent         # magia (doc 03)
├── StatsComponent             # HP, stamina, resistências — FONTE ÚNICA de atributos
├── AnimationTree + Skeleton3D # rig padrão (doc de personagens)
├── HurtboxComponent (Area3D)
└── InteractionRay (RayCast3D)
```

`StatsComponent` é a única fonte de verdade de HP/stamina/atributos. Outros componentes pedem modificações via métodos dele (`apply_damage()`, `drain_stamina()`), nunca alteram valores diretamente.

## Interfaces de entidade

Todo inimigo/NPC implementa os mesmos "contratos por convenção" (duck typing verificado com `has_method`):

- `StatsComponent` presente → pode receber dano.
- Grupo `"enemies"`, `"npcs"`, `"interactables"` para queries.
- Método `get_save_data() -> Dictionary` / `load_save_data(data)` → persistível.

## Cenas de teste ("gyms")

Cada sistema mantém em `tests/` uma cena executável isolada com placeholders:
- `tests/combat_gym.tscn` — arena com dummy que loga dano/poise.
- `tests/survival_gym.tscn` — sliders de temperatura/tempo acelerado.
- `tests/ai_gym.tscn` — corredores de percepção, botões de spawn.

**Critério de pronto de qualquer feature: funciona no gym sem carregar o mundo.**

## Convenções de código

- snake_case para arquivos/pastas, PascalCase para `class_name`.
- Um script por cena de componente; sem scripts de 1000 linhas — quebrar em componentes.
- Sinais no passado (`died`), métodos no imperativo (`apply_damage`).
- Unidades: metros, segundos, quilos. 1 unidade Godot = 1 metro.
- Git com LFS para `.glb`, `.png`, `.ogg`. Branch por sistema (`feat/combat-parry`).

## Ordem de dependência para integração

```
1. Arquitetura (autoloads, EventBus, DataRegistry, StatsComponent)
2. Física/Movimento  ──┐
3. Combate            ├─ dependem só de (1)
4. Inventário         │
5. Sobrevivência    ──┘
6. IA (depende de combate)
7. Magia (depende de combate + inventário)
8. Mundo aberto (depende de física)
9. Quests (depende de mundo + EventBus)
10. Save (depende de todos — mas só via get_save_data())
```

Arte, áudio e trilha sonora não têm dependência de código: entram por substituição de placeholders a qualquer momento.
