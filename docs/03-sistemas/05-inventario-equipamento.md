# Inventário, Equipamento e Crafting

> A mochila é uma decisão de gameplay (assinatura de Outward): o que você carrega define o que você aguenta.

## Peso e mochila

- Capacidade = 30 kg base + capacidade da mochila equipada (15–60 kg conforme o modelo).
- **A mochila é um item físico visível nas costas** com regras:
  - Mochila grande = penalidade de esquiva (roll vira cambalhota lenta).
  - **Largar a mochila** (botão dedicado) antes de lutar: esquiva plena, mas os itens ficam no chão — e podem ser saqueados se você fugir.
- Acima da capacidade: sem pulo, movimento −40% (dá pra arrastar loot pesado até perto, com dor).
- Classe de peso do **equipamento vestido** (armadura/armas) é separada e controla i-frames (ver combate).

## Slots de equipamento

| Slot | Notas |
|---|---|
| Mão direita / esquerda | arma, escudo, tocha, lanterna |
| Cabeça / Torso / Pernas / Botas / Luvas | armadura com peso, resistências, warmth |
| Mochila | capacidade + penalidades |
| Anéis ×2 | efeitos passivos |
| Cinto rápido ×8 | hotbar de consumíveis/skills |

Armadura tem stats de: proteção por tipo de dano, `warmth`/`heat_protection` (sobrevivência), peso, penalidade de stamina. **Trade-offs reais**: a melhor armadura de frio é ruim contra corte, etc.

## Durabilidade

- Armas/armaduras degradam por uso/dano. Em 0: arma −50% dano, armadura −70% proteção (nunca quebram para sempre — anti-frustração).
- Reparo: bancada em cidade (barato) ou kit de campo (consome material, repara 50%).

## Crafting

### Estações e categorias
| Estação | Onde | Crafta |
|---|---|---|
| Fogueira + panela | qualquer lugar | comida, chás, fervura de água |
| Bancada de campo | acampamento | flechas, bandagens, armadilhas, reparos parciais |
| Forja | cidades | armas/armaduras, reparo total |
| Mesa alquímica | cidades + torres perdidas | poções, antídotos, componentes de ritual |

### Regras
- Receita = `RecipeData extends Resource` (ingredientes com tags OU itens exatos, estação, resultado).
- **Descoberta por experimentação**: combinar itens sem receita conhecida testa contra o banco de receitas; sucesso → registra no diário. Falha → "mistura arruinada" (perde 1 ingrediente, não todos).
- Ingredientes por **tags** (`meat`, `bone`, `fungus_blue`) para que fauna regional diferente sirva às mesmas receitas base.

### Cozinha = buffs
Pratos são a fonte principal de buffs pré-combate: +resistência a frio, +regen stamina, +poise. Comida boa exige ingredientes de risco (carne de fera ressonante...) — caça vira preparação de chefe.

## Loot e contêineres

- `LootTableData` com entradas ponderadas + garantias; tabelas por região/criatura.
- Contêineres do mundo persistem estado (aberto/saqueado) no save.
- Cadáveres de inimigos saqueáveis por 5 min de jogo, depois somem (exceto únicos).
- **Sem loot mágico aleatório** — únicos são colocados à mão (ver progressão).

## Implementação em Godot

```gdscript
# InventoryComponent guarda Array[ItemStack]; ItemStack = { id: StringName, amount: int, durability: float }
# NUNCA guarda referência ao Resource — sempre id + DataRegistry (save-friendly).
```

- UI de inventário: lista com peso somado, ordenável por tag; drag & drop para equipar; tooltip com lore.
- Equipar emite `EventBus.equipment_changed` → `StatsComponent` recalcula modificadores; malha visual do personagem troca via `EquipmentVisualizer` (escuta o mesmo sinal — arte desacoplada).
- Itens no chão: cena `WorldItem` (RigidBody3D leve + Sprite/mesh), some após N min exceto flag `persistent`.
- Mochila largada: instancia `DroppedBackpack` com cópia do conteúdo; registrada no save da região.
- Gym: `tests/inventory_gym.tscn` — spawner de itens, balança de debug, bancadas de todas as estações.

## Anti-frustração (aprendizados de Outward)

- Filtro/busca no inventário desde o dia 1.
- Botão "guardar tudo de tag X" em estações (ingredientes direto da mochila).
- Peso mostrado SEMPRE no HUD ao pegar item.
- Nunca exigir item de quest que o jogador possa ter vendido sem aviso — itens de quest têm tag `quest` e aviso ao vender.
