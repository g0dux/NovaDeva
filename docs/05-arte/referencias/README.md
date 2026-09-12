# Banco de Referências Visuais — Nova Deva

> Concept art gerada para travar o estilo **Outward pintado + dark**, e para servir de brief de modelagem 3D. Estas imagens **não são assets finais** — são o norte visual.

## Como usar

1. Abrir este folder no **PureRef** (ou no Godot como texturas de referência).
2. Antes de modelar qualquer criatura: copiar a silhueta da referência e desenhar a versão low-poly por cima.
3. Checagem de aceite: se o modelo 3D não se parece com a referência a 30 m de distância, refazer a silhueta — não o detalhe.

## Estilo travado (o que copiar destas imagens)

| Copiar | Não copiar |
|---|---|
| Formas simples, textura pintada, saturação viva | Realismo fotográfico, pele porosa, PBR metal/rough extremo |
| Uma coisa errada por criatura (galhada-dedo, olhos demais) | Gore explícito, tentáculos em tudo, horror genérico |
| Osso Deva = marfim + musgo; osso Asura = vidro escuro + veios ciano | Mundo inteiro marrom-cinza |
| Mochila visível, viajante comum (não herói de armadura dourada) | Protagonista “chosen one” |

## Índice das imagens

### 1. Estilo de mundo — dualidade Deva / Asura
**Arquivo:** `style_dualidade_deva_asura.png`

O que modelar a partir daqui:
- **Kit anatômico Deva:** vértebra-colina, costelas como ruínas, osso pálido com musgo e flores.
- **Kit anatômico Asura:** túneis de carne vitrificada, veios emissivos ciano, correntes, círculos de sal.
- **Transição de dungeon:** raiz viva → raiz morta → parede Asura. Toda dungeon da região 1 deve repetir esse arco.

### 2. Personagens jogáveis
**Arquivo:** `player_viajantes.png`

O que modelar:
- 2 meshes-base (M/F), 7 cabeças, mãos/armas 10% maiores.
- Roupa de sobrevivência (couro + pano), **não** armadura de placas no look inicial.
- **Mochila grande nas costas** é obrigatória (identidade Outward).
- Slots visíveis: capa, cantil, saco de dormir, arma na mão + arma nas costas.

Orçamento: 40–60k tris no total (corpo + equipamento inicial).

### 3. NPCs e cultistas
**Arquivo:** `humanoides_cultista_npcs.png`

O que modelar (reusa `rig_humanoid_v1`):
| Figura | Uso | Notas de mesh |
|---|---|---|
| Cultista faca + máscara de vértebra | Inimigo Vale (prioridade 2 do pipeline) | Máscara = mesh extra no bone da cabeça |
| Cultista arqueiro | Variante do mesmo corpo | Troca só arma + capa |
| Mercador de Solva | NPC cidade | Corpo-base médio + roupa de kit Vale |
| Minerador de Forja-Vigília | NPC / inimigo leve região 2 | Cinza + acento laranja-brasa |

### 4. Fauna — Vale Vertebral
**Arquivo:** `fauna_vale_cervo_lobo.png`

| Criatura | “Uma coisa errada” | Prioridade |
|---|---|---|
| **Cervo-Galho** | Galhada de dedos ossudos | Região 1 |
| **Lobo Pálido** | Olhos demais na testa | **Prioridade 2 do pipeline** (valida fera + IA) |

Orçamento: 8–15k tris. Lobo precisa de rig quadrupede próprio (não o humanoide).

### 5. Monstros — Vale Vertebral
**Arquivo:** `monstros_vale_carrapato_guardiao.png`

| Criatura | Arquétipo | Detalhe de modelagem |
|---|---|---|
| **Carrapato de Medula** | Emboscador | Tamanho de cão; abdômen inchado; sem face humana |
| **Guardião de Casca** | Brutamontes | Madeira + osso; **coração fungal ciano** no peito = hitbox de fraqueza |

### 6. Monstros — Cinzas de Ombra
**Arquivo:** `monstros_cinzas_linha.png`

| Criatura | Arquétipo | Detalhe |
|---|---|---|
| Salamandra de Cinza | Fera | Pele rachada, brasas por baixo (emissivo no shader) |
| Peregrino Calcinado | Enxame | Estátua de cinza; silhueta humana quebradiça |
| Cantor do Coro | Ressonante | Boca costurada; peito aberto que “canta” (luz laranja) |
| Escaravelho de Fornalha | Brutamontes | Blindagem de osso-Asura; **barriga-fornalha** = fraqueza |

### 7. Monstros — Lamento Submerso
**Arquivo:** `monstros_lamento_linha.png`

| Criatura | Arquétipo | Detalhe |
|---|---|---|
| Mimo de Voz | Emboscador | Corpo = emaranhado de braços; sem rosto |
| Sanguessuga Colossal | Brutamontes | Translúcida; silhueta do que comeu visível |
| Afogado Devoto | Enxame | Peregrino que voltou errado; algas + osso de oração |
| Pescador de Lamento | Lanceiro | Alto, vara feita de costela; usa o jogador de isca |

### 8. Chefes (seleção)
**Arquivo:** `chefes_selecao.png`

| Chefe | Região | O que a imagem trava |
|---|---|---|
| Alfa da Caçada Pálida | Vale / evento noturno | Lobo colossal, coroa de galho-dedo, olhos demais |
| Jardineiro de Ossos | Dungeon | Humanoide alto plantando cadáveres como mudas |
| Verme Branco Jovem | Culto | Larva pálida do tamanho de uma carroça, ainda acorrentada |
| Casulo da Nova Deva | Ato final | Híbrido: verde vivo fundido em osso-Asura escuro + veios |

Os outros 4 chefes (Coração do Guardião, Mãe do Coro, Forja-Viva, Boca do Lamento) ainda não têm prancha — gerar quando a região correspondente entrar em produção.

## Ordem de modelagem (igual ao doc de personagens)

1. Player + mochila + espada 1M — usar `player_viajantes.png`
2. Lobo Pálido + Cultista faca — usar `fauna_vale_cervo_lobo.png` + `humanoides_cultista_npcs.png`
3. Resto do Vale — cervo, carrapato, guardião
4. Chefes 1–2 — alfa + jardineiro
5. Cinzas → Lamento

## O que ainda falta (próximo lote, se quiser)

- Turnaround ortográfico (frente/lado/costas) do player e do lobo — necessário para modelar no Blender sem inventar ângulo.
- Pranchas dos 4 chefes restantes.
- Kit de armaduras (leve / média / pesada) e as 8 armas.
- Moodboards só de cidade: Solva, Forja-Vigília, Pilar dos Afogados.
