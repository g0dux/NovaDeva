# NOVA DEVA — Documentação de Desenvolvimento

> RPG de ação em mundo aberto, estilo **Outward** com alma de **soulslike**, ambientado em um mundo fantástico sombrio e macabro. Desenvolvido em **Godot 4.x**.

## Como usar esta documentação

Cada módulo é **independente** e pode ser construído separadamente por pessoas ou equipes diferentes. As interfaces entre módulos (sinais, autoloads, formatos de dados) estão definidas em `03-sistemas/00-arquitetura-godot.md` — esse é o "contrato" que garante que tudo se encaixe no final.

## Índice

### 01 — Visão Geral
| Documento | Conteúdo |
|---|---|
| [GDD — Visão Geral](01-visao-geral/gdd-visao-geral.md) | Pilares de design, público, escopo, loop de gameplay |

### 02 — Mundo e Narrativa
| Documento | Conteúdo |
|---|---|
| [Mundo e Lore](02-mundo-narrativa/mundo-e-lore.md) | História do mundo, regiões, facções, tom narrativo |

### 03 — Sistemas de Jogo (Godot)
| Documento | Conteúdo |
|---|---|
| [Arquitetura Godot](03-sistemas/00-arquitetura-godot.md) | Estrutura do projeto, autoloads, sinais, contratos entre módulos |
| [Combate](03-sistemas/01-combate.md) | Combate soulslike: stamina, esquiva, parry, poise, armas |
| [Sobrevivência](03-sistemas/02-sobrevivencia.md) | Fome, sede, sono, temperatura, doenças (estilo Outward) |
| [Magia e Rituais](03-sistemas/03-magia.md) | Sistema de magia combinatória e ritualística |
| [Atributos e Progressão](03-sistemas/04-atributos-progressao.md) | Progressão horizontal por habilidades, sem level clássico |
| [Inventário e Equipamento](03-sistemas/05-inventario-equipamento.md) | Mochila, peso, crafting, durabilidade |
| [IA de Inimigos](03-sistemas/06-ia-inimigos.md) | Máquinas de estado, percepção, comportamento de grupo |
| [Mundo Aberto e Exploração](03-sistemas/07-mundo-aberto-exploracao.md) | Streaming de mundo, viagem sem fast-travel, mapa sem marcador |
| [Quests e Diálogo](03-sistemas/08-quests-dialogo.md) | Quests com consequência e tempo-limite, diálogos |
| [Save/Load e Persistência](03-sistemas/09-save-load.md) | Serialização do mundo, morte com consequência |

### 04 — Física
| Documento | Conteúdo |
|---|---|
| [Física do Jogo](04-fisica/fisica.md) | Movimento do personagem, colisões, ragdoll, hitboxes, camadas |

### 05 — Arte e Modelos 3D
| Documento | Conteúdo |
|---|---|
| [Direção de Arte](05-arte/01-direcao-de-arte.md) | Estilo visual (Outward + dark), paleta, referências |
| [Pipeline de Modelos 3D](05-arte/02-modelos-3d-pipeline.md) | Ferramentas, orçamento de polígonos, export para Godot |
| [Personagens](05-arte/03-personagens.md) | Player, NPCs, inimigos, criaturas, rigs e animação |
| [Ambientes e Cenários](05-arte/04-ambientes-cenarios.md) | Biomas, kits modulares, props, iluminação |
| [VFX e Shaders](05-arte/05-vfx-shaders.md) | Efeitos de magia, clima, shaders estilizados |
| [Referências visuais](05-arte/referencias/README.md) | Concept art do estilo, players, fauna, monstros e chefes |

### 06 — Áudio
| Documento | Conteúdo |
|---|---|
| [Trilha Sonora](06-audio/01-trilha-sonora.md) | Direção musical, temas por região, música adaptativa |
| [SFX e Ambiência](06-audio/02-sfx-e-ambiencia.md) | Efeitos sonoros, ambiências, implementação no Godot |

### 07 — Produção
| Documento | Conteúdo |
|---|---|
| [Roadmap](07-producao/roadmap.md) | Fases de desenvolvimento, marcos, ordem de construção |

## Regra de ouro dos módulos

1. **Nenhum módulo importa código de outro módulo diretamente.** A comunicação é feita por sinais globais (`EventBus`) e autoloads definidos na arquitetura.
2. **Arte e sistemas usam placeholders mútuos**: sistemas são testados com cápsulas/cubos; arte é validada em cenas de vitrine sem gameplay.
3. **Dados de jogo (itens, inimigos, magias) vivem em `Resource`s (.tres)**, nunca hardcoded — designers editam sem tocar em código.
