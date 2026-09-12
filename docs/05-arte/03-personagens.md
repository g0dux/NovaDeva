# Personagens, Criaturas e Animação

## Player

- 1 malha-base masculina + 1 feminina (proporções 7 cabeças, estilizadas), customização leve: rosto (blend shapes), pele, cabelo (6 opções).
- **Todo equipamento é visível**: armadura troca malhas por slot (cabeça/torso/pernas/botas/luvas), armas em `BoneAttachment3D` (mão + costas/cinto quando guardadas), **mochila sempre visível** (identidade Outward).
- Corrupção Ressonante ≥ 50: veias emissivas na pele (parâmetro do shader de personagem), olhos alterados — NPCs "veem" o que o jogador virou.

### Rig padrão humanoide
- Esqueleto único do projeto (`rig_humanoid_v1`, nomes de bones documentados no .blend base) usado por player e TODOS os humanoides → animações 100% compartilháveis via `AnimationLibrary`.
- Bones extras: 2 de capa/tecido (jigglebones via `SkeletonModifier`), attachment points: `hand_r`, `hand_l`, `back_weapon`, `back_pack`, `hip_l`.
- Retarget pelo `BoneMap` do Godot quando importar animações externas.

## Animação

| Conjunto | Qtd aprox. | Notas |
|---|---|---|
| Locomoção | 20 | idle/walk/run/sprint ×
 estados de peso (leve/pesado) + strafe de lock-on (blend space 2D) |
| Combate por arquétipo de arma | 12–18 × 8 armas | combos, pesado, guardado/sacar, bloqueio, parry, riposte |
| Reações | 10 | hit por direção, stagger, guard break, knockdown, levantar |
| Sobrevivência/interação | 15 | comer, beber, cozinhar, acampar, coletar, ritual, dormir |
| Magia | 10 | castos curto/longo/canalizado, sigilo no chão |

- **Root motion** em: rolls, ataques com deslocamento, ripostes (distâncias consistentes p/ balance).
- Fonte: animação própria em Blender + packs stylized comprados retargetados (aceito para locomoção; combate DEVE ser autoral — é o feel do jogo).
- `AnimationTree` padrão do projeto: state machine raiz (locomotion / combat / hit / interact) com sub-state machine por arquétipo de arma, trocada em runtime pelo `equipment_changed`.
- Method call tracks para hitboxes/sons de passo (contrato com combate/áudio).

## NPCs

- 3 corpos-base (magro/médio/robusto) × biblioteca de roupas por região + cabeças variadas = multidões críveis baratas.
- 12 NPCs "herói" (mestres, líderes de facção) com malha e silhueta únicas.

## Bestiário v1.0 (~25 inimigos, 6 arquétipos de IA)

### Vale Vertebral
| Criatura | Arquétipo IA | Design macabro |
|---|---|---|
| Cervo-Galho | Fera | galhada de dedos ossudos; foge, chifra se encurralado |
| Lobo Pálido / Alfa da Caçada | Fera/Enxame | pelagem branca, olhos demais |
| Cultista do Verme (faca/arco/oficiante) | humanoides | máscaras de vértebra costuradas |
| Carrapato de Medula | Emboscador | do tamanho de um cão, gruda e drena |
| Guardião de Casca | Brutamontes | golem de madeira+osso em volta de um coração fungal |

### Cinzas de Ombra
| Criatura | Arquétipo | Design |
|---|---|---|
| Salamandra de Cinza | Fera | brasas sob pele rachada |
| Peregrino Calcinado | Enxame (undead) | estátuas de cinza que andam quando não vistas de perto |
| Cantor do Coro | Ressonante | boca costurada que "canta" pelo peito aberto |
| Escaravelho de Fornalha | Brutamontes | tanque blindado, barriga incandescente = fraqueza |

### Lamento Submerso
| Criatura | Arquétipo | Design |
|---|---|---|
| Mimo de Voz | Emboscador | imita vozes de NPCs; corpo = maçaranduba de braços |
| Sanguessuga Colossal | Brutamontes | translúcida, vê-se o que comeu |
| Afogado Devoto | Enxame | peregrinos que entraram na água e voltaram errados |
| Pescador de Lamento | Lanceiro | pesca COISAS com vara; usa o jogador de isca |

### Chefes (8)
1. **Alfa da Caçada Pálida** (região 1, evento noturno)
2. **O Jardineiro de Ossos** (dungeon, humanoide alto que "planta" cadáveres)
3. **Coração do Guardião** (golem colosso — luta de escalada leve)
4. **Mãe do Coro** (região 2, ressonante, arena de pilares que "cantam")
5. **Forja-Viva** (construto de ossocarvão incandescente)
6. **A Boca do Lamento** (região 3, a "voz" de todas as imitações)
7. **Verme Branco Jovem** (culto — o que eles alimentavam)
8. **[Final por facção]** — variação do confronto na câmara da Nova Deva

Cada chefe: doc próprio de 1 página (moveset, fases, arena, música, recompensa) antes de produzir.

## Prioridade de produção

1. Player + rig + locomoção + espada 1M (vertical slice) — ref: `referencias/player_viajantes.png`
2. Lobo Pálido + Cultista faca (1 fera + 1 humanoide validam o pipeline inteiro) — refs: `fauna_vale_cervo_lobo.png`, `humanoides_cultista_npcs.png`
3. Restante da região 1 → chefes 1–2 → regiões 2 e 3

Concept art de todas as criaturas listadas acima: [`referencias/README.md`](referencias/README.md).
