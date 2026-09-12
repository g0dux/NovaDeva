# VFX e Shaders

## Shaders-base do projeto (poucos e paramétricos)

| Shader | Usa | Parâmetros-chave |
|---|---|---|
| `sh_character` | player, NPCs, criaturas | albedo, normal, ORM leve, **corruption_mask + corruption_amount** (veias emissivas), wetness, snow/ash |
| `sh_environment` | arquitetura, props, rochas | albedo, normal, trim/atlas UV, wetness global da região, moss/ash overlay por world-normal |
| `sh_foliage` | vegetação | wind sway (vertex), translucência simples, cor por região |
| `sh_water` | rios, pântano | profundidade→cor, espuma em bordas, distorção leve |
| `sh_resonance` | tudo que é "mágico" | fresnel emissivo pulsante na cor de acento da região, dissolve |
| `sh_fx_master` | partículas | aditivo/alpha, distorção, flipbook, soft particles |

Regra: variações são **parâmetros/instâncias**, nunca cópias de shader. Compilar variantes cedo (shader pre-compilation) para evitar stutter.

## VFX de gameplay (contrato com sistemas)

VFX escutam o EventBus — sistemas nunca instanciam efeitos diretamente:

| Sinal | VFX |
|---|---|
| `damage_dealt` | impacto por tipo de dano (slash=faísca branca, resonance=ondas do acento, decay=fiapos escuros) + hitstop já dado pelo combate |
| `spell_cast` | casto por escola (Cinzas=brasas, Mortalha=cristais, Víscera=filamentos vermelho-escuro, Eco=ondulações do ar) |
| `status_effect_applied` | aura discreta no personagem (nunca poluir a leitura do combate) |
| `ritual_completed` | setpiece de ritual (o efeito mais "generoso" do jogo) |

- Todas as partículas: `GPUParticles3D`; pooling via `VFXManager` (nó do módulo, spawn por id).
- Orçamento: efeito comum ≤ 200 partículas; nada de luz dinâmica em VFX comum (só chefes/rituais).

## Identidade visual das escolas de magia

| Escola | Linguagem visual |
|---|---|
| Cinzas | brasas, fuligem, luz laranja que ESCURECE ao morrer (cinza) |
| Mortalha | cristais finos, vapor frio, silêncio visual (poucas partículas, lentas) |
| Víscera | tendões de luz vermelho-escura, gotas que sobem, pulso de batimento |
| Eco | o ar "lembra" — ghosting/eco do movimento, ondas concêntricas invisíveis reveladas por poeira |

Sigilos no chão: `Decal` animado + anel de partículas; legíveis (inimigos também os veem).

## Clima e ambiente

- Chuva: GPU particles em caixa seguindo a câmera + ripples em `sh_water` + wetness global do ambiente sobe.
- Tempestade de fuligem: fog volumétrico denso + partículas laterais + máscara de ash no `sh_environment`.
- Fungos/Ressonância: emissivo pulsante sincronizado por região (um `global shader parameter` de fase — o mundo "respira" junto: sutil e perturbador).

## Feedback de UI/tela (Environment do player)

- Dano sofrido: vinheta vermelha curta. Sono baixo: bordas escurecendo lentas. Corrupção: saturação puxada ao acento + pulso nas bordas (ver direção de arte).
- Implementar como um `CanvasLayer` de overlays + tweaks no `Environment` via `ScreenFXManager` (escuta EventBus).

## Gym

`tests/vfx_gym.tscn`: botões que emitem cada sinal do contrato com dummies, sliders de clima, contador de partículas/draw calls. Arte de VFX é 100% desenvolvível aqui sem gameplay.
