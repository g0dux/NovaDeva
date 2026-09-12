# Quests e Diálogo

> Quests estilo Outward: objetivos claros, direções por texto (sem marcador), **janelas de tempo reais** e consequências permanentes. O mundo anda sem você.

## Tipos de quest

| Tipo | Quantidade v1.0 | Características |
|---|---|---|
| Campanha de facção | 3 linhas × 8 quests | Exclusivas por escolha de facção; definem o final |
| Quests paralelas | ~25 | Autocontidas, muitas com timer |
| Vinhetas | ~15 | Sem log formal: situações no mundo com resolução (o parasita, o mercador na estrada) |
| Contratos | repetíveis | Caça/entrega dos quadros de aviso; dinheiro (economia) |

## Regras de design

1. **Tempo-limite honesto:** quests com prazo declaram no diário ("o ancião disse que a caravana parte em 5 dias"). `WorldClock` conta; expirar dispara `quest_expired` e o mundo muda (a caravana partiu — encontre os destroços dela mais tarde).
2. **Falha é conteúdo:** toda quest com timer tem estado de falha escrito (não "quest failed" seco — consequência narrativa).
3. **Sem marcador:** direções no texto; opcionalmente NPC desenha um pino no SEU mapa (anotação automática justificada na ficção).
4. **Consequência > recompensa:** decisões mudam NPCs/locais permanentemente (loja fecha, vila é tomada, mestre morre e leva skills junto).

## Estrutura de dados

```gdscript
class_name QuestData extends Resource
@export var id: StringName
@export var title: String
@export var faction_lock: StringName        # "" = disponível a todos
@export var time_limit_days: float = 0.0    # 0 = sem prazo
@export var objectives: Array[ObjectiveData]
@export var outcomes: Array[OutcomeData]    # sucesso, falha, expirada, variantes
```

- `ObjectiveData`: tipo (ir_a_local, matar, coletar, falar, ritual, escoltar), parâmetros, texto de direção.
- `QuestManager` (node no GameState, não autoload próprio) escuta o EventBus: objetivos avançam por sinais (`entity_died`, `region_entered`, `ritual_completed`, `item_added`...) — quests NUNCA têm código nos objetos do mundo.
- Flags de mundo: `GameState.flags` (Dictionary de StringName→variant) para consequências ("solva_mercado_queimado" = true).

## Diálogo

- Sistema próprio simples OU plugin **Dialogue Manager** (Godot, maduro) — recomendação: usar o plugin, formato `.dialogue` em texto é ótimo para escritores e para diff no git.
- Recursos necessários: condições sobre flags/corrupção/facção, mutação de flags, inserir itens, abrir loja, iniciar quest.
- Sem dublagem na v1.0 (texto + "voz" murmurada estilo gibberish opcional). Câmera de diálogo simples (não cinemática) — escopo.
- NPCs importantes reagem a: facção do jogador, corrupção visível, quests concluídas, eventos da região.

## Diário do jogador

Abas: **Quests** (texto das direções, prazos em dias do mundo), **Receitas** descobertas, **Bestiário** (preenchido ao matar/observar), **Lore** (documentos achados). Tudo alimentado por sinais, serializado no save.

## Escrita — fluxo de produção

1. Outline de quest em planilha (id, gancho, passos, prazos, outcomes).
2. Review de design (checa: dá pra achar sem marcador? falha é interessante?).
3. Implementação data-driven (QuestData + .dialogue).
4. Playtest cego: um tester acha o objetivo só com as direções do texto? Se não, reescrever direções (não adicionar marcador).
