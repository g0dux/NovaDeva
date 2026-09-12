# Ambientes e Cenários

## Método: kits modulares por região

Cada região é construída com um **kit** (conjunto fechado de módulos + props + vegetação + trim sheets). Nada de assets únicos para lugares comuns; assets únicos só em POIs-assinatura.

### Composição de um kit de região
| Componente | Qtd | Exemplos |
|---|---|---|
| Módulos de arquitetura | 25–35 | paredes, esquinas, portais, telhados, escadas (grid 2 m, snapping) |
| Rochas/formações | 10–15 | 3 tamanhos, encaixáveis rotacionadas |
| **Peças de gigante** | 8–12 | costelas, vértebras, falanges, dentes — o "kit anatômico" da região, em 2 famílias de material (Deva/Asura) |
| Vegetação | 12–18 | 3 árvores + arbustos + grama (MultiMesh) + fungos emissivos |
| Props de vida | 20–30 | mobília, mercado, ferramentas, sinais de culto |
| Trim sheets | 4 | madeira, pedra, metal, osso |

### O kit anatômico (assinatura visual)
Peças de esqueleto de gigante em escala arquitetônica, reusáveis: uma costela é ponte na região 1, viga de mina na 2, quilha de barco na 3 (retexturizada). Modelar 1× em alta qualidade e variar por **material** — as mesmas malhas servem às duas raças:
- **Osso de Deva:** pálido/marfim, musgo e flores crescendo por cima, tratado com reverência (corrimãos, lamparinas — as pessoas VIVEM nele).
- **Osso de Asura:** escuro, vítreo, veios emissivos de Ressonância, sinais de contenção (correntes antigas, círculos de sal — as pessoas o EVITAM).

## Assentamentos

| Cidade | Conceito visual |
|---|---|
| Enclave de Cinzarel | vila de pescadores entre os dedos de uma mão colossal; redes, madeira clara |
| Solva | mercado vertical dentro de vértebra oca; luz entra pelo canal medular (god ray permanente) |
| Forja-Vigília | fortaleza-mina; fornalhas de ossocarvão tingem tudo de laranja; sinos de vigia |
| Pilar dos Afogados | palafitas em espiral ao redor do braço erguido; lamparinas âmbar contra a chuva |

Cada cidade precisa de: 1 landmark visível de longe, loja/estalagem/quadro de contratos/mestre de skill, e 3 "vinhetas" de vida (NPCs fazendo coisas).

## Dungeons (10–12)

- **Regra da lore: descer = entrar em território Asura.** Quase toda dungeon segue o arco visual: entrada em terra fértil de Deva → transição (raízes morrendo, fungos emissivos aparecendo) → carne/osso de Asura corrompido e tóxico no fundo. O jogador SENTE a mudança de dono do território.
- Tipos: cavernas de medula de Asura, ruínas do culto (o Verme Branco cava em direção a eles), minas de ossocarvão abandonadas, **interiores de órgãos calcificados** (dungeon dentro de um coração de Asura acorrentado — assinatura do jogo).
- Zonas tóxicas dentro de dungeons: ar envenenado visível (fog + partículas) que interage com sobrevivência/status — proteção craftável necessária para os fundos mais ricos.
- Regras: legível sem mapa; 1 atalho desbloqueável de volta à entrada; 1 setpiece visual único por dungeon; iluminação autoral (LightmapGI).

## Vegetação e terreno

- Grama/folhagem baixa: `MultiMeshInstance3D` pintada no terreno, com wind sway no shader (vertex animation).
- Árvores: 3 LODs + impostor; atlas por região.
- Terreno: material de splat 4 camadas (pintado), + decals de trilha nas rotas principais (estradas guiam o olhar).

## Storytelling ambiental (checklist por POI)

Todo POI responde três perguntas SEM texto: quem esteve aqui? o que aconteceu? por que voltar? Ferramentas: composição de cadáveres/props, sinais de culto, cor de acento da Ressonância, contraste luz/sombra.

## Skybox e clima visual

- Céu procedural + camadas de nuvens por região; a "cor do céu" é personagem (ver direção de arte).
- Clima: chuva (partículas GPU + shader de molhado global por região), tempestade de fuligem (fog volumétrico + partículas + vinheta), névoa densa (fog exponencial, distância de visão cai para 40 m — tensão).

## Orçamento por região

- ~2×2 km jogáveis; alvo ≤ 2000 draw calls na vista pior; usar HLOD manual (malhas combinadas para distância) em assentamentos.
- Streaming por setores (ver doc mundo aberto); autoria da região no editor com `Node3D` por setor desde o início (não reorganizar depois).

## Ordem de produção

1. Kit da região 1 (Vale Vertebral) completo → cena-vitrine aprovada
2. Greybox da região 1 inteira (level design com primitivos) → playtest de navegação
3. Dressing da região 1 com o kit
4. Solva → dungeons da região 1 → regiões 2, 3 (kits reaproveitam % do anatômico)
