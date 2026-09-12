# Mundo Aberto e Exploração

> Estrutura de Outward: regiões grandes conectadas por transições, viagem real (sem fast travel), mapa sem "você está aqui". A viagem É o jogo.

## Estrutura do mundo

- **Regiões separadas por cenas** (não um mundo contíguo único): cada região é uma cena Godot própria (~2×2 km jogáveis), conectada por transições com loading (portões, passagens de montanha).
  - Vantagens: produção paralela por região, streaming simples, ferramentas padrão da engine.
- Dungeons/interiores são cenas separadas dentro da região (porta = transição).
- Dentro da região: **chunking por visibilidade** — o mundo é dividido em setores; props/inimigos de setores distantes são descarregados (nodes removidos, estado guardado em `RegionState`).

## Viagem sem fast travel

- Não há teleporte. Existem **atalhos desbloqueáveis** (pontes reparadas, portões abertos por dentro — metroidvania leve) e **caravanas pagas** entre cidades (viagem "off-screen" que consome tempo do mundo e comida, com chance de evento de emboscada jogável).
- Corrida drena stamina fora de combate lentamente; a velocidade-base de viagem deve tornar cruzar uma região ≈ 12–15 min — longo o bastante para exigir preparação, curto o bastante para não entediar.
- **Ritual Vela dos Perdidos** (magia) e marcos visuais fortes (o braço erguido, a vértebra oca) são as ferramentas de orientação.

## Mapa e orientação

- Mapa = ilustração artística da região (estilo mapa desenhado), **sem posição do jogador**, sem marcadores automáticos.
- Jogador pode comprar mapas melhores e **anotar manualmente** (pinos + texto).
- Quests dão direções textuais/visuais ("norte do rio, onde as costelas encontram a névoa").
- Bússola no HUD (item equipável barato — sem ela, só sol/estrelas).

## Ciclo de dia/noite e clima

- `WorldClock` (autoload): dia = 40 min; emite `time_of_day_changed`.
- Noite: escuridão REAL (tocha/lanterna necessárias fora de estradas), inimigos noturnos, temperatura cai.
- `WeatherSystem` por região com estados (limpo, chuva, tempestade de fuligem, névoa densa...) e transições; emite `weather_changed`. Clima afeta: temperatura, visão da IA, sigilos (magia), áudio.
- Céu: `Sky` procedural + `DirectionalLight3D` animada; cores por região definidas pela direção de arte.

## Pontos de interesse (POI) — densidade

Meta por região: **1 POI significativo a cada 90 s de caminhada** em qualquer direção. Tipos:

| Tipo | Qtd/região | Conteúdo |
|---|---|---|
| Dungeon grande | 3–4 | 20–40 min, chefe ou tesouro único |
| Ruína/caverna pequena | 8–10 | 5–10 min, loot, lore |
| Acampamento inimigo | 6–8 | combate/stealth opcional |
| Vinheta de lore | 10+ | cena ambiental que conta história (sem combate) |
| Recurso raro | 5–6 | ingrediente de crafting de risco |
| Altar/ritual site | 2–3 | interação com sistema de magia |

**Regra:** todo POI é visível ou insinuado de outro POI ou estrada (level design por "weenies" — silhuetas no horizonte guiam).

## Persistência do mundo

- `RegionState` (dict por região no save): contêineres saqueados, inimigos mortos (com timer de respawn de dias de jogo), portas/atalhos abertos, mochilas largadas, sigilos ativos não.
- Respawn de inimigos: 3 dias de jogo para comuns; chefes e únicos NÃO respawnam.
- Recursos colhíveis respawnam em 2 dias.

## Implementação em Godot

- Cena de região: `Region (Node3D)` com filhos `Terrain`, `POIs`, `Spawners`, `ClimateZones`, `NavigationRegion3D`.
- Terreno: **Terrain3D** (plugin consolidado) ou malha esculpida no Blender por região — decidir no protótipo da região 1 (avaliar ferramentas de pintura/erosão vs. controle artístico).
- Transições: `Area3D` portal → tela de load estilizada (dica de lore) → `SceneLoader` troca região com `ResourceLoader.load_threaded_*`.
- Spawners: `EnemySpawner` com `EnemyData` + condições (hora, clima, flag de quest); dormem quando o setor descarrega.
- Oclusão: `OccluderInstance3D` em formações grandes; `VisibleOnScreenNotifier3D` para VFX caros.
- **Orçamento de performance:** 16.6 ms/frame alvo em GPU média (GTX 1660): mundo ≤ 4 ms de script, ≤ 2000 draw calls. Medir no gym de região desde cedo.

## Gym

`tests/world_gym.tscn`: região de teste 500×500 m com 1 de cada POI-tipo, sliders de hora/clima, contador de FPS/draw calls, teleporte de debug.
