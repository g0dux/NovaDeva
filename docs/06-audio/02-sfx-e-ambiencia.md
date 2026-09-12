# SFX e Ambiência

## Filosofia

Com música esparsa (ver trilha), a **ambiência é a trilha sonora de 60% do jogo**. O terror do jogo vive aqui: o vento na costela oca, a coisa que imita vozes, o silêncio errado.

## Buses de áudio

```
Master
├── Music
├── SFX
│   ├── SFX_Combat      (prioridade no mix; sidechain → Music)
│   ├── SFX_Foley       (passos, pano, mochila)
│   ├── SFX_World       (portas, interações, crafting)
│   └── SFX_Magic
├── Ambience
│   ├── Amb_Bed         (camas de loop por região)
│   └── Amb_Spot        (one-shots 3D: corvos, galhos, gotas)
├── Voice               (gibberish/murmúrio de NPCs, criaturas "falantes")
└── UI
```

Reverb por zona: `Area3D` de reverb (caverna, vértebra oca, chuva aberta) trocando `AudioEffectReverb` do bus SFX/Ambience via snapshots.

## Ambiência por região (2 camadas + spots)

| Região | Cama base | Spots | Assinatura macabra |
|---|---|---|---|
| Cinzarel | mar, gaivotas, madeira rangendo | redes, sinos de barco | um "batimento" lentíssimo sob o mar (a mão) |
| Vale Vertebral | vento em folhas pálidas, madeira | corvos, galhos, fungos estalando | a floresta SILENCIA quando a Caçada está perto (remoção de som = alarme) |
| Cinzas de Ombra | vento de cinza, rangido térmico | desmoronamentos distantes, sinos da Vigília | o "coro" térmico ao meio-dia — quase música |
| Lamento Submerso | chuva, água, madeira de palafita | bolhas, coisas mergulhando | vozes distantes que repetem frases que NPCs já disseram ao jogador |

Dia/noite troca as camas (crossfade de 30 s via `time_of_day_changed`).

## SFX de gameplay (contrato com sistemas)

Tudo dirigido por sinais/method tracks — o módulo de áudio é substituível sem tocar em código de gameplay:

| Fonte | Implementação |
|---|---|
| Passos | method track na animação → `FootstepPlayer` raycasta material do chão (grama/pedra/água/osso) + peso do equipamento altera camada de "tralha" da mochila |
| Golpes | `damage_dealt`: whoosh (no ataque) + impacto por tipo de dano × material do alvo (carne/osso/metal/madeira) |
| Parry/guard break | sons-assinatura únicos e MUITO claros (feedback de gameplay > realismo) |
| Magia | `spell_cast` por escola (Cinzas=combustão; Mortalha=cristal+ausência; Víscera=úmido; Eco=reverso/sugado) |
| Sobrevivência | comer/beber/fogueira/tremer de frio; barriga roncando como AVISO de fome (áudio como UI) |
| UI | cliques de madeira/osso discretos; abrir mochila = som de tralha |

- Variação: mínimo 4 amostras por som frequente + random pitch ±5% (`AudioStreamRandomizer`).
- Pooling: `AudioManager.play_sfx(id, position)` com pool de `AudioStreamPlayer3D` (32) — nunca instanciar player por tiro.
- Atenuação: máx. audível ~40 m para combate, 80 m para sinos/eventos (som como informação de mundo).

## Vozes

- Sem dublagem v1.0. NPCs: murmúrio gibberish curto por "tom" (saudação/medo/raiva) + criaturas com vocalizações próprias.
- **Mimo de Voz** (região 3): reproduz clipes gibberish de NPCs que o JOGADOR já ouviu (guardar últimos N ids ouvidos) — assinatura de horror sonoro do jogo.

## Especificações

- .ogg 48 kHz; one-shots mono (3D espacializa), camas stereo.
- Loudness alvo do mix final: −16 LUFS jogo geral; TP ≤ −1 dB.
- Nomenclatura: `sfx_categoria_nome_v01.ogg` (`sfx_step_grass_v03`), tabela em `data/audio/`.
- Fonte: gravação própria + bibliotecas licenciadas (registrar licenças em `audio/LICENSES.md`).

## Gym

`tests/audio_gym.tscn`: pisos de todos os materiais, botões de cada sinal do contrato, zonas de reverb, sliders de hora/clima, medidor de players ativos.
