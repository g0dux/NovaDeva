# Direção de Arte

> "Outward corrompido": o mesmo painterly estilizado, legível e colorido de Outward — mas o mundo por baixo é um cadáver. Beleza melancólica com detalhes que incomodam quando você olha de perto.

## Estilo base (o que copiamos de Outward)

- **Formas simplificadas, texturas pintadas à mão** (hand-painted / stylized PBR leve): pouco detalhe de micro-superfície, cores chapadas com variação pintada, normal maps suaves.
- **Legibilidade acima de realismo:** silhuetas de inimigos reconhecíveis a 50 m; itens equipados visíveis e distintos no personagem.
- **Céus dramáticos** dominando a composição; skybox é 30% do impacto visual do jogo.
- Saturação moderada-alta em vegetação e céu — Nova Deva NÃO é marrom-cinza. O dark vem do conteúdo, não da dessaturação global.

## A camada macabra (o que adicionamos)

0. **A dualidade Deva/Asura é a regra visual nº 1 do jogo:**
   - **Terra de Deva (superfície, cidades):** fértil ao ponto do excesso — verdes saturados, frutos grandes demais, vida febril. Bonito com algo de errado.
   - **Terra de Asura (subterrâneos, zonas amaldiçoadas):** corrompida e tóxica — carne negra vitrificada, veios emissivos de Ressonância, ar visível (partículas/fog esverdeado).
   - O jogador deve saber ONDE está (e o quão perigoso é) só pela paleta e pela densidade de vida, sem UI. Descer numa dungeon é literalmente atravessar essa transição visual.
1. **Anatomia como arquitetura:** costelas-ponte, vértebras-torre, dentes-minério. Sempre com dupla leitura: bonito de longe, perturbador ao entender o que é. Osso de Deva = pálido, quase marfim, venerado; osso de Asura = escuro, vítreo, evitado.
2. **Bioluminescência doentia:** fungos azul-pálidos e âmbar crescendo onde há Ressonância — a luz bonita marca os lugares errados (proximidade de carne de Asura).
3. **Fauna levemente errada:** animais reconhecíveis com UMA coisa errada (cervo com galhada de dedos; corvos com olhos demais). Uncanny dosado.
4. **Sinais de culto:** feixes de ossos pendurados, tecidos encerados, círculos de sal — storytelling ambiental de que "alguém esteve aqui e reza para a coisa errada".

## Paleta por região

| Região | Base | Acento | Céu |
|---|---|---|---|
| Enclave de Cinzarel | verdes suaves, areia clara | azul-mar | dourado quente (segurança) |
| Vale Vertebral | verde-musgo profundo, madeira pálida | azul fungal ciano | névoa fria, luar verde-acinzentado |
| Cinzas de Ombra | cinza-quente, ocre queimado | laranja-brasa | pôr-do-sol permanente sujo de fuligem |
| Lamento Submerso | verde-lodo, azul-petróleo | âmbar bioluminescente | chuva, cinza-esverdeado |

Regra: cada região tem **1 cor de acento** reservada para "coisas de Ressonância" — o jogador aprende a ler perigo/segredo pela cor.

## Iluminação

- Dia: `DirectionalLight3D` + céu procedural; sombras suaves; cor da luz por região/hora (gradiente animado pelo WorldClock).
- Noite: escuridão jogável-mas-real; tochas/fogueiras são pontos de composição quente vs. noite fria.
- Interiores/dungeons: iluminação autoral por luzes colocadas; volumetric fog moderado (Forward+) para god rays em aberturas.
- Global illumination: `SDFGI` para exteriores (dinâmico com dia/noite), `LightmapGI` para interiores fixos.

## Pós-processamento (Environment padrão)

- Tonemap ACES ou AgX, leve; bloom sutil (forte só em Ressonância); vignette dinâmica ligada a status (sono baixo, corrupção).
- SEM film grain/chromatic aberration por padrão (limpeza estilo Outward).
- Corrupção alta altera o pós do jogador: saturação puxada ao acento da região, bordas pulsando levemente — o mundo visto por olhos corrompidos.

## Personagem e materiais

- Proporções levemente estilizadas (7 cabeças, mãos/armas 10% maiores que o real — leitura).
- Um **shader-base único de personagem/props** (ver doc de VFX/shaders) com: albedo pintado, normal suave, máscara de smoothness simples, slot de "corrupção" (veias emissivas) e de neve/molhado por região.

## Processo e referências

- Banco interno já gerado em [`referencias/`](referencias/README.md) — começar por `style_dualidade_deva_asura.png`. Completar com moodboard por região (PureRef): 60% Outward/screenshots stylized, 40% referência macabra (Bloodborne, Scorn *dosado*, arte de Zdzisław Beksiński para formas, Hollow Knight para "fofo-macabro" de criaturas).
- **Cena-vitrine por região** (`art/showcase_<região>.tscn`): 30×30 m com kit, iluminação e paleta aprovadas — é o padrão-ouro que todo asset novo deve encaixar.
- Toda peça de concept passa por checagem: "é legível? é Outward? tem a segunda leitura macabra?"
