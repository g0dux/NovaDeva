# Save/Load, Morte e Persistência

## Filosofia de save

- **Um save por personagem, autosave contínuo** (estilo Outward): sem save scumming — decisões e derrotas ficam. É o que dá peso aos pilares 1 e 3.
- Autosave: ao trocar de região, dormir, completar quest, a cada 5 min, e **no momento da derrota** (antes do cenário de derrota rodar — sem reroll).
- Slot manual de backup a cada hora (proteção contra corrupção de arquivo, não contra decisões).

## Derrota ≠ morte (cenários de derrota)

Ao zerar HP, dispara `player_defeated` com contexto (região, causa, inimigos). O `DefeatDirector` sorteia um cenário válido para o contexto — o jogo continua SEMPRE:

| Cenário | Contexto | Resultado |
|---|---|---|
| Resgatado | perto de estrada/cidade | acorda na cidade, deve dinheiro ao resgatador |
| Capturado | derrotado por humanoides | acorda em jaula no acampamento — fuga jogável, itens num baú local |
| Deixado para trás | feras | acorda no local, HP queimado alto, mochila espalhada por perto |
| Arrastado para baixo *(macabro)* | zonas de Ressonância | acorda numa sub-caverna desconhecida, com corrupção +15 e uma "memória" de lore |
| Colhido *(raro, macabro)* | região 3 à noite | acorda no Pilar dos Afogados com o Parasita Lamento e sem lembrar do trajeto |

Regras: nunca destruir itens permanentemente (podem estar distantes/em risco, nunca deletados); nunca dois cenários iguais em sequência; chefes de quest têm cenário fixo escrito.

## Arquitetura de serialização

### Formato
- JSON (dicionários Godot → `JSON.stringify`) na v1.0; comprimido com gzip. Legível para debug, diff-ável.
- `user://saves/<character_id>/save.json` + `backup_N.json` + `meta.json` (nome, tempo, thumbnail).
- **`save_version: int` no topo** + pipeline de migração (`Migrations.migrate(data, from_version)`) desde o dia 1 — barato agora, impossível depois.

### Contrato (já definido na arquitetura)
Todo sistema persistível implementa:

```gdscript
func get_save_data() -> Dictionary
func load_save_data(data: Dictionary) -> void
```

`SaveManager` (autoload) agrega:

```
{
  "save_version": 3,
  "world":   { clock, weather, flags, quest states },
  "player":  { stats, position+region, inventory (ids+amounts+durability),
               skills, corruption, needs, status_effects },
  "regions": { "vale_vertebral": { containers, kills+respawn timers,
               shortcuts, dropped_backpacks, disturbed_things }, ... },
  "npcs":    { dead/moved/attitude flags }
}
```

- Itens/inimigos/skills salvos **por id** (`StringName` do DataRegistry), nunca por resource path ou índice.
- Regiões não visitadas não têm entrada (estado default vem da cena).
- Save de região atualiza ao SAIR da região (o resto vem dos autoloads a qualquer momento).

### Load
1. Carregar JSON, migrar versão.
2. Restaurar autoloads (clock, flags, quests).
3. Carregar cena da região do player (threaded, tela de load).
4. Aplicar `RegionState` (remover mortos, marcar contêineres, spawnar mochilas largadas).
5. Instanciar player, aplicar dados, emitir `region_entered`.

## Regras anti-perda

- Escrita atômica: salvar em `save.tmp` → verificar parse → rename sobre o antigo.
- Nunca salvar durante transição de cena ou com player em estado `defeated` não-resolvido.
- Ao detectar save corrompido: oferecer backups automaticamente, nunca tela de erro seca.

## Testes obrigatórios

- Round-trip: salvar → carregar → salvar → os dois JSONs são idênticos.
- Soak: 50 transições de região com autosave sem vazamento de nodes (monitorar contagem de órfãos).
- Migração: save da versão N−2 carrega na N.
- Derrota em cada região dispara cenário válido e o save resultante carrega.
