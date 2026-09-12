# Sistema de Sobrevivência

> O coração "Outward" do jogo: fome, sede, sono e temperatura transformam viagem em planejamento. Sobrevivência cria fricção interessante, nunca micromanagement chato.

## Filosofia

- Necessidades caem **devagar** (uma expedição de 1–2h real sem comer só chega a penalidades leves).
- Penalidades são **debuffs graduais**, nunca morte direta por fome.
- A exceção é **temperatura extrema**, que pode matar — é o perigo ambiental "hard" das regiões 2 e 3.

## As quatro necessidades

Todas em 0–100, gerenciadas pelo `SurvivalComponent`, emitindo `EventBus.need_changed`.

### Fome
- Decai ~4/h de jogo (dia de jogo = 40 min reais → ~2.7 por dia... ajustar no tuning).
- **< 50:** regen de HP por descanso reduzida. **< 25:** stamina máx −15%. **< 10:** HP máx −20%, tela dessaturada.
- Comida cozida > crua: pratos dão **buffs** (o incentivo é o buff, não evitar a fome). Comida crua pode causar doença.

### Sede
- Decai 1.5× mais rápido que fome; calor acelera.
- **< 50:** regen stamina −20%. **< 25:** custo de stamina +25%. **< 10:** dano de Decay lento.
- Cantis enchem em água limpa; água parada exige fervura (senão risco de doença).

### Sono
- Decai só com tempo acordado + acelera com magia e corridas longas.
- **< 40:** janela de parry −2 frames (sutil e cruel). **< 20:** visão escurece nas bordas, sussurros no áudio (tie-in macabro). **< 10:** micro-cochilos: blackout de 1s aleatório fora de combate.
- Dormir requer **kit de acampamento** (tenda, saco) ou pousada. Dormir no mato = risco de emboscada (roll baseado na região + fogueira acesa reduz risco).
- Ao dormir o jogador aloca horas entre: dormir / vigiar / reparar / cozinhar (menu estilo Outward).

### Temperatura
- Escala de −100 (congelando) a +100 (calor letal); alvo é a **zona neutra** [−25, +25].
- Fontes: região, hora do dia, clima, altitude, fogueiras, água (molhado = frio), equipamento (`ItemData.warmth` / `heat_protection`), poções, comida quente.
- **Fora da zona:** drain de stamina crescente → depois HP. Extremos (>|80|) aplicam `Hypothermia`/`Heatstroke` (movimento lento, tela com efeito).
- Regiões: Vale Vertebral = frio leve à noite; Cinzas de Ombra = ciclo brutal quente-dia/frio-noite; Lamento Submerso = molhado constante.

## Doenças e ferimentos (status macabros)

Sistema de `StatusEffectData extends Resource` genérico (usado também por combate e magia):

| Status | Causa | Efeito | Cura |
|---|---|---|---|
| Indigestão | comida crua/podre | sede acelerada, stamina −10% | chá, tempo |
| Febre do Pântano | água suja, região 3 | sono decai 2×, sudorese (sede) | antídoto craftado |
| Ferida Aberta | crits sofridos, quedas | HP queimado cresce com esforço | bandagem |
| Corrupção Ressonante | magia, zonas de Ressonância | veias escuras na tela; NPCs reagem; +dano mágico sofrido | ritual de purificação (caro) |
| Miasma de Asura | ar tóxico em subterrâneos (carne de Asura exposta) | dano de Decay contínuo enquanto exposto; acelera corrupção | sair da zona; máscara/filtro craftado permite explorar os fundos |
| Parasita Lamento | dormir sem proteção na região 3 | rouba comida ao comer; sussurra | cirurgia em cidade (quest-vinheta) |

**Corrupção Ressonante** é o status "assinatura": magia poderosa custa corpo e mente. É risco/recompensa, não só punição — algumas skills ficam MAIS fortes corrompido.

## HP queimado (Burnt HP)

Dano grave converte parte do HP perdido em HP "queimado" (teto reduzido, mostrado em cinza na barra). Só recupera dormindo/comendo bem/tratando. É o que faz expedições longas serem desgastantes sem punir com morte.

## Implementação em Godot

```gdscript
# systems/survival/survival_component.gd
class_name SurvivalComponent extends Node
# Necessidades tickam a cada 1s de jogo (Timer), NUNCA em _process.
# Modificadores ambientais vêm de Area3D "ClimateZone" no mundo + WorldClock + WeatherSystem.
```

- **ClimateZone (Area3D):** áreas no mundo com `temperature_offset`, `wetness`, `resonance_level`. O componente soma zonas ativas + clima global.
- **Fogueira:** cena interativa com `Area3D` de calor (offset decai com distância), slot de cozinhar, e flag `campfire_lit` usada pelo roll de emboscada.
- Status effects são nodes filhos de `StatusEffectContainer`, cada um com timer e stacks próprios; serializáveis para o save.
- UI escuta `need_changed` — nunca lê o componente diretamente (permite testar sem UI).
- Gym: `tests/survival_gym.tscn` com sliders de tempo/clima e multiplicador de velocidade 60×.

## Tuning inicial (data/survival_tuning.tres)

| Parâmetro | Valor inicial |
|---|---|
| Duração do dia de jogo | 40 min reais |
| Fome: cheio → penalidade leve | ~2 dias de jogo |
| Sede: cheio → penalidade leve | ~1 dia de jogo |
| Sono: acordado → penalidade | ~1.5 dias de jogo |
| Temperatura letal: tempo até morrer em −100 | 4 min reais (com avisos crescentes) |

## Regra anti-tédio

Se playtests mostrarem que jogadores pausam expedições só para "dar manutenção" nas barras mais de 1× por sessão de 30 min, **reduzir taxas de decaimento em 25%** e reforçar buffs de comida. Sobrevivência deve puxar decisões de preparação, não interromper a diversão.
