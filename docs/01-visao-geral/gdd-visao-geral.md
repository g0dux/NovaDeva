# NOVA DEVA — GDD: Visão Geral

## Conceito em uma frase

> Um RPG de sobrevivência e exploração em mundo aberto onde você é um viajante comum — não um herói escolhido — tentando sobreviver a um mundo fantástico, sombrio e indiferente, com combate exigente estilo soulslike e magia perigosa de aprender.

## Pilares de Design

Todos os sistemas devem ser avaliados contra estes 4 pilares. Se uma feature não serve a nenhum pilar, ela sai.

### 1. Você é mortal
- Sem level scaling: o mundo não se adapta a você; você se adapta ao mundo.
- Fome, sede, frio e ferimentos importam. Preparação > reflexo.
- A morte **não é game over**: você acorda capturado, resgatado ou despojado em outro lugar (sistema de "cenários de derrota" do Outward), mas em Nova Deva as consequências são mais macabras (ver `03-sistemas/09-save-load.md`).

### 2. Combate deliberado (soulslike)
- Stamina governa tudo: atacar, esquivar, bloquear, correr.
- Animações com commit — não há cancelamento livre de ataque.
- Leitura de inimigos, punição de erro, poise/stagger.
- Peso do equipamento altera esquiva e velocidade.

### 3. O mundo não te guia
- Sem marcador de quest automático. O mapa não mostra sua posição exata.
- Direções são dadas por referências ("siga o rio até a torre quebrada").
- Quests têm janelas de tempo e consequências permanentes.

### 4. Beleza macabra
- Estética de Outward (cores pintadas, formas legíveis, céus dramáticos) corrompida por elementos de horror: a dualidade dos gigantes mortos — terra fértil e exuberante demais sobre corpos de **Devas**, subterrâneos corrompidos e tóxicos onde jazem os **Asuras** — e vilas que veneram coisas que não deviam.
- O horror vem da atmosfera e da lore, não de jumpscares.

## Fantasia do Jogador

"Sou um viajante despreparado num mundo que quer me matar. Cada expedição é planejada como uma escalada: mochila, comida, poções, rota, plano de fuga. Quando sobrevivo, a vitória é minha — não do meu level."

## Loop de Gameplay

```
PREPARAR (cidade)          →  VIAJAR (mundo aberto)       →  ENFRENTAR (dungeon/evento)
comprar/craftar/cozinhar      sobrevivência + exploração     combate soulslike + loot
        ↑                                                            │
        └──────────────  RETORNAR (ou ser derrotado)  ←──────────────┘
                         vender, aprender skills, avançar quests
```

- **Loop curto (minutos):** combate, gestão de stamina, decisões de rota.
- **Loop médio (sessão):** expedição completa — preparação, viagem, objetivo, retorno.
- **Loop longo (campanha):** avançar facções, aprender escolas de magia, desvendar o mistério do Grande Colapso e da Nova Deva.

## Referências

| Jogo | O que pegamos |
|---|---|
| **Outward** | Sobrevivência, mochila, sem level scaling, cenários de derrota, viagem "de verdade", estilo de arte |
| **Dark Souls / Elden Ring** | Feel do combate, stamina, poise, design de chefes, lore ambiental |
| **Dragon's Dogma** | Sensação de peso e física no combate, viagens noturnas perigosas |
| **Fear & Hunger** | Tom macabro, crueldade do mundo (dosada — Nova Deva é menos punitivo) |
| **Shadow of the Colossus** | Escala melancólica, gigantes mortos como cenário |

## Escopo (versão 1.0)

| Item | Meta |
|---|---|
| Regiões de mundo aberto | 3 (uma por bioma principal) + região tutorial |
| Cidades/assentamentos | 4 |
| Dungeons únicas | 10–12 |
| Chefes únicos | 8 |
| Tipos de inimigos | ~25 |
| Escolas de magia | 4 |
| Armas (arquétipos) | 8 (espada 1M, espada 2M, machado, lança, adaga, arco, escudo+arma, cajado) |
| Duração da campanha | 30–40h |
| Plataforma alvo | PC (Steam), specs médias de 2020+ |
| Engine | Godot 4.x (Forward+) |

## Público-alvo

Jogadores de Outward, soulslikes e RPGs de sobrevivência que valorizam imersão e desafio sobre conveniência. Classificação alvo: 16+ (violência, temas sombrios, sem gore gratuito).

## O que Nova Deva NÃO é

- Não é um looter com level scaling e loot colorido.
- Não é multiplayer (v1.0 é single-player; co-op é candidato pós-lançamento).
- Não é um jogo de terror com sustos — é dark fantasy atmosférico.
- Não é um mundo gigante vazio: 3 regiões densas > 10 regiões rasas.
