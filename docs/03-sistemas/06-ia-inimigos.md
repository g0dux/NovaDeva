# IA de Inimigos e NPCs

> Inimigos legíveis e críveis > inimigos "espertos". A IA existe para criar cenas de combate justas e momentos de tensão na exploração.

## Arquitetura

Cada inimigo:

```
Enemy (CharacterBody3D)
├── StatsComponent            # mesmo do player (simetria)
├── AIBrain (FSM)             # decide estado
├── PerceptionComponent       # visão/audição
├── NavigationAgent3D         # locomoção
├── CombatComponent (variante)# executa ataques do moveset
├── AnimationTree
└── Hurtbox/Hitboxes
```

**FSM sobre behavior trees** para a v1.0: estados explícitos são mais fáceis de debugar e suficientes para o design. Estados como nodes filhos de `AIBrain` (padrão state-as-node).

### Estados universais

```
IDLE/PATROL → SUSPICIOUS → ALERT → COMBAT → { ATTACK, REPOSITION, RECOVER }
                    ↓                            ↓
                 SEARCH  ←────────────  LOST_TARGET
COMBAT → FLEE (por moral)      qualquer → STAGGERED/DEAD
```

## Percepção

- **Visão:** cone (ângulo+alcance por espécie) + raycast de oclusão. Modificado por: luz (noite reduz), postura do jogador (agachado), Mortalha (magia).
- **Audição:** eventos sonoros do jogador (passo, combate, magia) emitem `SoundEvent` numa `Area3D` esférica; correr faz barulho, andar molhado mais ainda.
- Detecção é **gradual** (medidor 0→100): SUSPICIOUS investiga o ponto, ALERT persegue. Tag `unaware` (para backstab) só em IDLE/PATROL/SUSPICIOUS.
- Inimigos alertam aliados num raio ao entrar em COMBAT (grito — pode ser interrompido matando rápido).

## Combate da IA

### Legibilidade primeiro
- Todo ataque tem **telegraph** (animação + flash/som) ≥ 0.5s.
- Regra dos souls: máx **2 inimigos atacando ativamente** o jogador ao mesmo tempo; os demais circulam (token system: `AttackTokenManager` por grupo).

### Perfis de comportamento (data-driven)
`EnemyData extends Resource` define: agressividade (freq. de ataque), coragem (limiar de FLEE), distância preferida, moveset (lista de `AttackData` com alcance/cooldown/condições), fraquezas/resistências, tabela de loot, sentidos.

Arquétipos v1.0 (~25 inimigos derivam destes 6 comportamentos):

| Arquétipo | Comportamento |
|---|---|
| Fera | agressiva, flanqueia, foge com HP baixo, ataques rápidos |
| Brutamontes | lento, hiperarmadura, ataques de área, quebra guarda |
| Lanceiro/Range | mantém distância, reposiciona, fraco em melee |
| Enxame | fracos individualmente, moral coletiva (fogem se o grupo cai) |
| Emboscador | invisível/enterrado até proximidade, burst alto, frágil |
| Ressonante | usa magias/sigilos, invoca, prioridade de alvo |

### Chefes
- FSM própria com fases; scripts por chefe são aceitáveis (não generalizar demais).
- Diretores de fase trocam `AttackData` pools e arena (colunas quebram, etc.).

## Inimigos na exploração (não só combate)

- **Territórios:** inimigos têm `home_area`; perseguem até o limite + 20 m e voltam (permite fuga estratégica — viajar é jogável).
- **Ecologia leve:** feras caçam outras criaturas se cruzarem; cultistas patrulham rotas com tochas visíveis de longe (jogador planeja por observação).
- **Eventos noturnos:** a "Caçada Pálida" (região 1) spawna um grupo caçador à noite que segue rastros do jogador (fogueira acesa o atrai; ritual de Vigília protege).

## NPCs de cidade

- Agenda simples por hora do mundo (loja de dia, casa à noite) — `ScheduleData` com waypoints.
- Reações a estado do jogador: corrupção alta → falas diferentes/recusa de comércio; arma em punho na cidade → guardas avisam.
- Sem sistema de crime completo na v1.0 (fora de escopo).

## Implementação em Godot

- `NavigationRegion3D` por chunk de mundo; re-bake offline, não em runtime.
- Física da IA: `CharacterBody3D` + `NavigationAgent3D` com avoidance ligado só em grupos.
- **LOD de IA:** inimigos a >60 m do jogador tickam a 10 Hz e pausam animação; >120 m congelam (só posição salva). Essencial para mundo aberto.
- Debug overlay (F3): estado atual, medidor de percepção, alvo, token de ataque — em texto sobre cada inimigo.
- Gym: `tests/ai_gym.tscn` com corredores de visão/som, spawn de cada arquétipo e player-dummy controlável.

## Métricas de validação

- Jogador consegue passar furtivamente por um acampamento observando patrulhas (sem skills de stealth).
- Fuga de combate é viável em ~10 s de corrida para fora do território.
- Zero casos de inimigo girando/preso em navmesh em 30 min de play (bug budget).
