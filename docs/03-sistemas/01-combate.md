# Sistema de Combate

> Combate soulslike: deliberado, punitivo, governado por stamina. Preparação e leitura valem mais que reflexo puro.

## Visão geral

- **Terceira pessoa**, lock-on opcional em alvos.
- Toda ação ofensiva/defensiva consome **stamina**; stamina zerada = vulnerabilidade total.
- Ataques têm **commit**: uma vez iniciada a animação ativa, não há cancelamento (exceto janelas explícitas de combo/esquiva).
- **Sem level scaling**: o dano vem do equipamento, das skills aprendidas e da execução.

## Recursos do jogador

| Recurso | Comportamento |
|---|---|
| **HP** | Só regenera com comida, poções, sono. Ferimentos graves criam "HP queimado" (teto reduzido até tratar — estilo Outward) |
| **Stamina** | Regenera rápido fora de ação; regen pausa 0.8s após gasto; fome/frio reduzem o teto |
| **Poise (postura)** | Invisível ao jogador como número; acumula ao ser atingido; ao estourar → stagger |
| **Ressonância (mana)** | Ver doc de magia — máximo trocado permanentemente por HP/stamina em altares |

## Ações de combate

| Ação | Custo stamina (base) | Notas |
|---|---|---|
| Ataque leve | 15 | Combo de até 3; janela de encadeamento nos últimos 30% da animação |
| Ataque pesado | 30 | Carregável; quebra guarda; dano de poise alto |
| Esquiva (roll) | 20 | i-frames dependem da classe de peso (ver abaixo) |
| Passo lateral | 10 | Curto, sem i-frames, mantém lock-on — para ajuste de posição |
| Bloqueio | drena por hit | Escudo/arma têm `stability`: % do dano/stamina absorvido |
| **Parry** | 15 | Janela ativa 8 frames (a 60fps); sucesso → riposte com dano crítico |
| Chute/empurrão | 12 | Quebra guarda de inimigos escudados; empurra em bordas |
| Ataque em queda/furtivo | 25 | Backstab exige tag `unaware` do sistema de IA |

### Classes de peso (integra com Inventário)

| Classe | % do peso máx. equipado | Esquiva | Regen stamina |
|---|---|---|---|
| Leve | < 30% | Roll rápido, 12 i-frames | 100% |
| Média | 30–70% | Roll médio, 9 i-frames | 85% |
| Pesada | > 70% | "Fat roll", 5 i-frames | 65% |

Emitir `EventBus.weight_class_changed` quando mudar.

## Pipeline de dano

Todo dano passa por uma única função para consistência:

```gdscript
class_name DamageInfo extends RefCounted
var amount: float
var type: StringName        # "slash","blunt","pierce","fire","frost","resonance","decay"
var poise_damage: float
var knockback: Vector3
var source: Node
var can_be_blocked := true
var can_be_parried := true
```

Ordem de resolução em `StatsComponent.apply_damage(info)`:
1. i-frames ativos? → ignora.
2. Parry na janela? → emite `parried`, stagger no atacante, retorna.
3. Bloqueando? → aplica `stability`, drena stamina; se stamina zera → guard break.
4. Aplica resistências por tipo (equipamento + buffs + status).
5. Aplica dano, acumula poise; poise estourou → stagger.
6. Emite `EventBus.damage_dealt` (UI, áudio e VFX escutam — nunca chamados diretamente).

### Tipos de dano e identidade

- **Slash/Pierce/Blunt** — físicos; blunt é forte contra armadura/esqueletos.
- **Fire/Frost** — elementais; interagem com sobrevivência (fogo aquece, frost congela stamina regen).
- **Resonance** — "mágico" do mundo; ignora armadura física, aumenta corrupção.
- **Decay** — dano ao longo do tempo, reduz HP máximo temporariamente (assinatura macabra do jogo).

## Armas (8 arquétipos)

Cada arquétipo é um `WeaponData extends ItemData` com moveset próprio (AnimationTree sub-state machine):

| Arquétipo | Identidade | Especial |
|---|---|---|
| Espada 1M | Equilibrada, tutorial | Riposte aprimorado |
| Espada 2M | Dano/poise altos, lenta | Ataque carregado com hiperarmadura |
| Machado | Anti-escudo | Ignora 40% de stability |
| Lança | Alcance, recuo | Ataques andando para trás |
| Adaga | Rápida, crítico | Multiplicador de backstab 2.5× |
| Arco | Distância, munição finita | Zoom + tiro carregado; flechas craftáveis |
| Escudo + arma | Defensivo | Parry com escudo tem janela +4 frames |
| Cajado | Canal de magia | Ver doc de magia |

**Durabilidade:** armas degradam com uso; quebradas causam 50% de dano. Reparo em bancadas ou kits de campo (integra com crafting).

## Inimigos e chefes

- Inimigos usam o MESMO pipeline de dano/stamina/poise do jogador (simetria = legibilidade).
- Chefes têm barra de poise visível e 2–3 fases com mudança de moveset.
- Regra de design: **todo ataque de chefe tem telegraph de ≥ 0.5s** e uma resposta correta (esquivar, bloquear, parry, afastar).

## Implementação em Godot

### Hitboxes por animação
- `Hitbox (Area3D)` filhos dos bones da arma via `BoneAttachment3D`.
- Ativação por **método call tracks** na animação (`hitbox.activate()` / `deactivate()`), nunca por timers.
- `Hurtbox (Area3D)` em camada própria (ver doc de física, camadas 6/7).
- Hitbox guarda `Array` de alvos já atingidos por swing para evitar multi-hit.

### Máquina de estados do jogador
`CombatComponent` roda uma FSM leve (nós filhos ou `enum` + match):
`IDLE → ATTACK_WINDUP → ATTACK_ACTIVE → ATTACK_RECOVERY → (combo window) → ...`
Estados de hit: `STAGGER`, `KNOCKDOWN`, `GUARD_BREAK`. A FSM comanda o `AnimationTree`; a animação comanda as hitboxes.

### Lock-on
- `Area3D` de detecção (raio 15 m) + filtro por linha de visão (raycast).
- Alvo atual vira `look_at` suavizado da câmera; troca de alvo por flick do stick/mouse.

### Tuning
Todos os números deste doc vivem em `data/combat_tuning.tres` (um `Resource` só), editável sem recompilar. O gym `tests/combat_gym.tscn` tem dummy com log de DPS/poise na tela.

## Métricas de validação (playtest)

- Tempo médio para matar inimigo comum do early game: 8–15 s.
- Jogador zera stamina em ~4 rolls ou 5 ataques leves consecutivos.
- Parry deve ser arriscado: taxa de sucesso esperada de jogador médio < 40%.
- Nenhum ataque inimigo sem contra-resposta clara (auditar em review de chefes).
