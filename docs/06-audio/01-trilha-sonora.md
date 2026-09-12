# Trilha Sonora

## Direção musical

> "Folk de um mundo enterrado": instrumentos acústicos íntimos (referência Outward — violão/cordas de câmara) sobre camas texturais sombrias. A música lamenta os gigantes mortos; não é épica — é elegíaca, e fica ameaçadora quando o mundo fica.
>
> **A dualidade Deva/Asura também é sonora:** terra de Deva = acústico, consonante, orgânico; território Asura (subterrâneos, zonas corrompidas) = o mesmo material musical **processado** — reverso, detuned, dissonante, com sub-drones. O jogador ouve de quem é o chão.

- **Referências:** OST de Outward (intimismo acústico), Hollow Knight (melancolia melódica), Bloodborne (coros/dissonância — dosar), Dark Souls (temas de chefe com identidade), trilhas de Jóhann Jóhannsson (textura orquestral sombria).
- **Instrumentação-base:** violão de nylon, cello, viola de arco, harpa; **camada macabra:** coro sussurrado, ossos/percussão de madeira seca, harmônicos de arco esticados, drones de sub, "canto" processado (a voz das Devas).
- Tema principal do jogo: melodia de 6–8 notas ("motivo da Deva") que reaparece variado em regiões, chefes e no final — cola emocional do jogo.

## Música por contexto

| Contexto | Comportamento |
|---|---|
| Exploração diurna | faixas esparsas, 40–60% de SILÊNCIO (ambiência assume); a música entra em momentos (amanhecer, avistar landmark) |
| Exploração noturna | drones e texturas, sem melodia — tensão baixa constante |
| Cidades | tema próprio por cidade, diegese quando possível (músico de rua em Solva toca o tema da região) |
| Combate comum | camada rítmica/tensa que ENTRA sobre a textura atual (ver camadas) |
| Chefes | faixa exclusiva por chefe, 2 seções (fases) + stinger de vitória |
| Eventos (Caçada Pálida, Maré) | tema-assinatura do evento — o jogador aprende a temer a música |
| Derrota/cenários | peça curta melancólica por cenário |

## Sistema de música adaptativa (camadas verticais + trechos horizontais)

Implementação própria em Godot (sem middleware na v1.0; avaliar FMOD apenas se limites aparecerem):

- Cada "faixa" = conjunto de **stems sincronizados** (.ogg, mesmo BPM/duração): `base`, `melody`, `tension`, `combat_perc`, `combat_full`.
- `MusicDirector` (parte do AudioManager) reproduz stems em `AudioStreamPlayer`s sincronizados e faz crossfade de volumes por estado (explore/suspicious/combat/boss), lendo o EventBus (`damage_dealt`, percepção da IA via sinal `alert_state_changed`, `boss_fight_started`...).
- Transições horizontais (troca de faixa) apenas em barras: stems com marcação de BPM; trocar no próximo compasso (agenda com `AudioServer.get_time_since_last_mix` para precisão).
- Regra anti-fadiga: após 90 s de combate contínuo, `combat_full` recua para `combat_perc` (loop longo não cansa).

### Lista de produção (v1.0, ~35 peças)

| Grupo | Qtd |
|---|---|
| Tema principal + variações | 1 + 3 |
| Regiões (explore dia/noite × 4 áreas) | 8 conjuntos de stems |
| Cidades | 4 |
| Combate regional | 3 |
| Chefes | 8 |
| Eventos de mundo | 3 |
| Derrota/cenários + stingers | ~5 curtas |

## Especificações técnicas

- Formato: .ogg vorbis, 48 kHz; stems em loop sem clique (crossfade embutido ou loop points no import do Godot).
- Loudness: música a −23 LUFS integrado nas camas de exploração, −18 em chefes; sempre deixar headroom para SFX de combate (mix: combate se ouve SOBRE a música).
- Buses: `Music` separado com ducking sidechain leve a partir do bus `SFX_Combat` (implementar ducking via `AudioEffectCompressor` com sidechain no bus Music).
- Entregável por faixa: stems .ogg + arquivo `MusicTrackData.tres` (BPM, compasso, mapeamento de stems→estados) — compositor entrega e o sistema consome sem programador.

## Processo

1. Compositor recebe: doc de direção + paleta da região + captura de gameplay do greybox.
2. Sketch de 60 s aprovado antes da produção completa.
3. Teste in-game no `tests/audio_gym.tscn` (botões de estado forçado) antes do aceite final.
