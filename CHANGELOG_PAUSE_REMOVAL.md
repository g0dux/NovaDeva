# Changelog - Remoção do Sistema de Pause

**Data**: 2026-09-12  
**Commit**: `1caf03b`  
**Motivo**: Feedback do usuário - o sistema de pause/congelar não faz sentido para o fluxo do jogo

## 🎯 Objetivo

Remover completamente a mecânica de pause/congelar do jogo, garantindo que o jogo continue fluindo normalmente sem travas de tempo.

## ✅ Mudanças Implementadas

### Código-fonte

#### `scripts/autoload/game_manager.gd`
- ❌ Removido estado `PAUSED` do enum `GameState`
- ❌ Removido função `toggle_pause()`
- ❌ Removido handler `_input()` que escutava `ui_pause`
- ❌ Removido `process_mode = Node.PROCESS_MODE_ALWAYS`
- ❌ Removido chamadas `get_tree().paused`
- ✅ Estados restantes: `MENU`, `PLAYING`, `LOADING`

#### `scripts/ui/hud.gd`
- ❌ Removido case `PAUSED` do match de estados
- ✅ HUD agora mostra apenas 3 estados

#### `scenes/ui/hud.tscn`
- ❌ Removido "Enter - Pausar" do texto de instruções
- ✅ Texto agora: "WASD - Movimento | Espaço - Pular | ESC - Mouse"

#### `project.godot`
- ❌ Removido input mapping `ui_pause` (tecla Enter/Return)
- ✅ Mantidos apenas inputs de gameplay

### Documentação

Todos os documentos foram atualizados para remover menções ao pause:

- `PROJETO_GODOT.md` - Controles e features
- `PROJECT_OVERVIEW.md` - Descrições e exemplos
- `BOOTSTRAP_SUMMARY.md` - Checklist de funcionalidades
- `VERIFICATION_CHECKLIST.md` - Lista de verificação

## 📊 Estatísticas

- **Arquivos modificados**: 8
- **Linhas removidas**: 38
- **Linhas adicionadas**: 5
- **Funções removidas**: 2 (`toggle_pause`, `_input`)
- **Estados removidos**: 1 (`PAUSED`)
- **Input mappings removidos**: 1 (`ui_pause`)

## ✅ Verificação

### Comportamento Esperado

✅ **F5** inicia o jogo normalmente  
✅ **Jogo roda continuamente** sem interrupções  
✅ **Enter não faz nada** (como desejado)  
✅ **ESC** continua liberando/capturando o cursor  
✅ **Estados válidos**: MENU → PLAYING → LOADING  

### Código Limpo

✅ Sem referências a `PAUSED`  
✅ Sem função `toggle_pause`  
✅ Sem `get_tree().paused`  
✅ Sem `process_mode` especial  
✅ Sem input `ui_pause`  

## 🔗 Links

- **Commit**: https://github.com/g0dux/NovaDeva/commit/1caf03b
- **Pull Request**: https://github.com/g0dux/NovaDeva/pull/1
- **Branch**: `cursor/bootstrap-godot-project-a22c`

## 📝 Notas

- O arquivo `docs/04-fisica/fisica.md` contém menções a "freeze" que se referem à física de objetos (RigidBody.freeze), não ao sistema de pause. Essas referências foram mantidas pois são válidas e diferentes do sistema removido.

- Todos os outros sistemas do jogo permanecem intactos: movimento, pulo, câmera, HUD, GameManager (estados restantes).

---

**Status**: ✅ Completo  
**Testado**: Aguardando teste no Godot Editor  
**Próxima ação**: Merge do PR após aprovação
