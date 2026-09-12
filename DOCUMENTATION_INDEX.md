# 📚 Índice de Documentação - NovaDeva

Este repositório contém documentação extensa sobre o projeto. Use este índice para navegar facilmente.

## 📋 Documentação Geral

- **[README.md](README.md)** - Visão geral do projeto e instruções básicas (PT-BR)
- **[PROJETO_GODOT.md](PROJETO_GODOT.md)** - Especificação técnica completa do projeto
- **[PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)** - Arquitetura e organização do projeto
- **[BOOTSTRAP_SUMMARY.md](BOOTSTRAP_SUMMARY.md)** - Resumo da implementação inicial
- **[VERIFICATION_CHECKLIST.md](VERIFICATION_CHECKLIST.md)** - Checklist de testes e validação

## ⚔️ Sistemas de Jogo

- **[COMBAT_SYSTEM.md](COMBAT_SYSTEM.md)** - Documentação completa do sistema de combate corpo a corpo

## 📝 Changelogs & Histórico

- **[CHANGELOG_PAUSE_REMOVAL.md](CHANGELOG_PAUSE_REMOVAL.md)** - Remoção do sistema de pause (não fazia sentido para o jogo)
- **[AI_INVENTORY_SURVIVAL.md](AI_INVENTORY_SURVIVAL.md)** - Implementação de IA de inimigos, inventário e sobrevivência
- **[CHANGELOG_TYPE_INFERENCE_FIX.md](CHANGELOG_TYPE_INFERENCE_FIX.md)** - Correção detalhada de inferência de tipos (linha por linha)

## 🔧 Correções Técnicas

### Correção de Inferência de Tipos (Godot 4.3+)

**Problema:** Parser Error "variable type is being inferred from a Variant value"

Documentos relacionados:
1. **[EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md)** - 📌 **LEIA ESTE PRIMEIRO** - Resumo executivo para o usuário
2. **[VERIFICATION_TYPE_FIX.md](VERIFICATION_TYPE_FIX.md)** - Verificação e validação das correções
3. **[CHANGELOG_TYPE_INFERENCE_FIX.md](CHANGELOG_TYPE_INFERENCE_FIX.md)** - Changelog detalhado com todas as mudanças

**Resumo rápido:**
- ✅ 13 arquivos corrigidos
- ✅ ~60 variáveis com tipagem explícita
- ✅ Zero uso de `:=` remanescente
- ✅ Projeto abre sem erros no Godot 4.3+

## 🎮 Como Começar

1. **Novo no projeto?** → Leia [README.md](README.md)
2. **Quer entender a arquitetura?** → Leia [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)
3. **Teve erro de parser ao abrir?** → Leia [EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md)
4. **Quer entender o combate?** → Leia [COMBAT_SYSTEM.md](COMBAT_SYSTEM.md)
5. **Quer ver o histórico completo?** → Veja a seção [Changelogs & Histórico](#-changelogs--histórico)

## 📊 Estrutura do Repositório

```
NovaDeva/
├── scripts/          # Scripts GDScript (.gd)
│   ├── autoload/     # Autoloads (GameManager)
│   ├── player/       # Player e controles
│   ├── combat/       # Sistema de combate (Stats, Combat, DamageInfo)
│   ├── enemy/        # IA e inimigos (AIBrain, AsuraGrunt)
│   ├── inventory/    # Sistema de inventário
│   ├── survival/     # Sistema de sobrevivência (fome/sede)
│   ├── items/        # Itens coletáveis
│   └── ui/           # Interface (HUD, menus)
├── scenes/           # Cenas Godot (.tscn)
│   ├── main/         # Cena principal
│   ├── player/       # Player com componentes
│   ├── enemy/        # Inimigos (AsuraGrunt)
│   └── items/        # Itens coletáveis
├── data/             # Recursos de dados (.tres)
│   └── items/        # Definições de itens (ItemData)
├── assets/           # Assets (texturas, modelos, áudio)
└── docs/             # Documentação adicional

```

## 🔗 Links Úteis

- **Pull Request**: [#1 - Bootstrap completo do projeto Godot 4 jogável](https://github.com/g0dux/NovaDeva/pull/1)
- **Branch Principal**: `cursor/bootstrap-godot-project-a22c`
- **Engine**: Godot 4.3+

## 📌 Documentos Mais Importantes

Para usuários que estão começando agora:

1. 🌟 **[EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md)** - Resumo executivo da correção de tipos
2. 🌟 **[README.md](README.md)** - Visão geral do projeto
3. 🌟 **[PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)** - Arquitetura do projeto
4. 🌟 **[COMBAT_SYSTEM.md](COMBAT_SYSTEM.md)** - Sistema de combate

## 💬 Contribuindo

Ao fazer mudanças no projeto:
1. Mantenha a documentação atualizada
2. Crie changelogs para features novas
3. Use tipagem explícita em GDScript (ex: `var x: float = 1.0`)
4. Teste no Godot 4.3+ antes de commitar

---

**Última atualização:** 2026-09-12  
**Versão do projeto:** Bootstrap Completo  
**Compatibilidade:** Godot 4.3+
