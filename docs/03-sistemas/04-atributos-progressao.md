# Atributos e Progressão

> Progressão **horizontal**, como Outward: sem níveis, sem XP. O personagem fica mais capaz por equipamento, skills compradas/conquistadas e conhecimento do jogador.

## Por que sem level

- Mantém o mundo perigoso do início ao fim (pilar 1).
- Faz cada skill/equipamento novo ser um evento memorável.
- Elimina grind como resposta a dificuldade — a resposta é preparação e execução.

## Atributos base (StatsComponent)

| Atributo | Valor inicial | Como aumenta |
|---|---|---|
| HP máx | 100 | Comida rara permanente (+5, limitada), escolhas de breakthrough |
| Stamina máx | 100 | idem |
| Ressonância máx | 0 | Comprada em Altar de Medula (troca permanente por HP/stamina) |
| Capacidade de carga | 30 kg + mochila | Mochilas melhores |
| Resistências (7 tipos de dano) | 0% | Equipamento, buffs, skills passivas |

**Não existem** força/destreza/inteligência. Requisitos de arma não existem — qualquer um usa qualquer arma; a diferença vem das skills.

## Árvores de Skill

- Skills são compradas de **mestres-NPCs** com dinheiro (economia importa) e às vezes quest.
- 8 mestres no mundo (um por escola de magia + 4 marciais: Mercenário, Caçador, Monge do Sepulcro, Vagante).
- Cada árvore: ~6 skills baratas + **1 breakthrough** + 2–3 skills de elite pós-breakthrough.

### Limite de Breakthrough: 3 por personagem

Como em Outward: o jogador só pode adquirir **3 breakthroughs** de árvores diferentes — é a "classe" emergente do personagem e a fonte de rejogabilidade. Exemplo de builds:

- Mercenário + Cinzas + Caçador → guerreiro de arma flamejante com arco.
- Víscera + Mortalha + Vagante → assassino de sangue furtivo.

### Exemplo de árvore — Mercenário (Solva)

| Skill | Custo | Efeito |
|---|---|---|
| Postura Firme | 50 prata | +15% stability ao bloquear |
| Golpe Bruto | 80 | ataque especial: pesado com bônus de poise dmg |
| Fôlego de Veterano | 100 | −10% custo de stamina de ataques |
| **BREAKTHROUGH: Talhe de Guerra** | 500 + quest | +40 stamina máx; ataques pesados não podem ser interrompidos |
| Elite: Execução | 300 | finisher em inimigos em stagger |
| Elite: Muralha | 300 | bloquear perfeito (timing) reflete poise damage |

## Skills ativas — implementação

- `SkillData extends Resource`: id, tipo (ativa/passiva), custo de stamina/ressonância, cooldown, animação, requisitos.
- Ativas entram na **hotbar** (8 slots); passivas aplicam modificadores no `StatsComponent` via sistema de modificadores:

```gdscript
# Modificadores nunca alteram o valor base — são camadas:
# final = (base + soma_flat) * produto_percentuais
stats.add_modifier("stamina_cost", -0.10, source="skill_folego_veterano")
```

## Progressão de conhecimento (invisível)

Metade da progressão real é o jogador aprender: receitas que descobre, rotas seguras, fraquezas de inimigos, combinações de magia. Suportar isso com:
- **Diário automático** que registra receitas/lore descobertos (sem spoiler do não-visto).
- Receitas de crafting só aparecem depois de descobertas (experimentação recompensada).

## Economia como progressão

- Dinheiro (prata) é o gate principal de skills e equipamento bom → loot e comércio importam.
- Preços regionais: comprar barato em Solva, vender caro em Forja-Vigília (incentiva rotas de comércio — e viagens perigosas com mochila valiosa e pesada: tensão).

## Legendary/único

Sem raridade colorida. Itens únicos existem escondidos no mundo com nome próprio e lore — encontrá-los É a recompensa. Zero drop aleatório de únicos.
