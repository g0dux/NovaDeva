# 🎮 Nova Deva - Project Overview

## 🚀 Quick Start

```bash
# 1. Clone o repositório
git clone https://github.com/g0dux/NovaDeva.git

# 2. Abra no Godot Engine 4.3+
# File → Import → Selecione project.godot

# 3. Pressione F5 para jogar!
```

## 📊 Project Structure

```
NovaDeva/
│
├── 🎮 PROJETO GODOT (JOGÁVEL)
│   │
│   ├── project.godot              # ⚙️ Configuração principal
│   ├── icon.svg                   # 🎨 Ícone do projeto
│   │
│   ├── 🎬 scenes/                 # Cenas do jogo
│   │   ├── main/
│   │   │   └── main.tscn          # 🌍 Cena principal (ambiente de teste)
│   │   ├── player/
│   │   │   └── player.tscn        # 🏃 Personagem jogável
│   │   ├── ui/
│   │   │   └── hud.tscn           # 🖥️ Interface (HUD)
│   │   └── environment/           # 🌳 (preparado para cenários)
│   │
│   ├── 💻 scripts/                # Scripts GDScript
│   │   ├── autoload/
│   │   │   └── game_manager.gd    # 🎯 Gerenciador global (singleton)
│   │   ├── player/
│   │   │   └── player.gd          # 🎮 Controlador do player
│   │   ├── ui/
│   │   │   └── hud.gd             # 📊 Lógica da UI
│   │   └── environment/           # 🏔️ (preparado para ambientes)
│   │
│   └── 📦 assets/                 # Assets do jogo
│       ├── textures/              # 🖼️ Texturas (preparado)
│       ├── models/                # 🗿 Modelos 3D (preparado)
│       ├── audio/                 # 🔊 Sons e música (preparado)
│       └── fonts/                 # 🔤 Fontes (preparado)
│
├── 📚 docs/                       # Documentação completa do projeto
│   ├── 01-visao-geral/           # 📖 GDD e visão do jogo
│   ├── 02-mundo-narrativa/       # 🌌 Lore e mundo (Devas/Asuras)
│   ├── 03-sistemas/              # ⚙️ Arquitetura e sistemas
│   ├── 04-fisica/                # 🎯 Física e mecânicas
│   ├── 05-arte/                  # 🎨 Arte e referências visuais
│   ├── 06-audio/                 # 🎵 Áudio e sound design
│   └── 07-producao/              # 📅 Roadmap e planejamento
│
└── 📄 Documentação do Bootstrap
    ├── README.md                  # 📌 Visão geral do projeto
    ├── PROJETO_GODOT.md          # 🎮 Guia completo de uso
    ├── BOOTSTRAP_SUMMARY.md      # 📊 Resumo executivo técnico
    └── VERIFICATION_CHECKLIST.md # ✅ Checklist de verificação

```

## 🎯 What's Playable Right Now

### ✅ Implemented Systems

| Sistema | Status | Descrição |
|---------|--------|-----------|
| **Player Movement** | ✅ | WASD para movimento 3D fluido |
| **Jump System** | ✅ | Pulo com física realista |
| **Camera Control** | ✅ | Terceira pessoa com mouse |
| **Game Manager** | ✅ | Estado global do jogo |
| **HUD** | ✅ | Interface básica com título e info |
| **Test Environment** | ✅ | Ambiente 3D com plataformas |

### 🎮 Controls

```
🕹️ MOVEMENT
   W/A/S/D    → Move player
   Space      → Jump
   Mouse      → Rotate camera

⚙️ SYSTEM
   ESC        → Release/capture mouse cursor
```

## 🏗️ Architecture Overview

### Autoload Singleton Pattern

```gdscript
# GameManager é acessível globalmente
GameManager.current_state    # Estado do jogo
GameManager.player           # Referência ao player
```

### Signal-Based Events

```gdscript
# GameManager emite signals
GameManager.game_state_changed.connect(_on_state_changed)

# Estados disponíveis
enum GameState {
    MENU,     # Menu inicial
    PLAYING,  # Jogando
    LOADING   # Carregando
}
```

## 📈 Development Roadmap

### ✅ Phase 0: Bootstrap (COMPLETE)
- [x] Projeto Godot configurado
- [x] Estrutura de pastas
- [x] Player controller básico
- [x] Game manager
- [x] Ambiente de teste

### 🔜 Phase 1: Core Mechanics (Next)
- [ ] Sistema de combate básico
- [ ] Primeiro inimigo com IA
- [ ] Sistema de vida/morte
- [ ] Assets visuais customizados

### 🔜 Phase 2: Survival Systems
- [ ] Inventário
- [ ] Fome/sede
- [ ] Crafting básico
- [ ] Sistema de save/load

### 🔜 Phase 3: World Building
- [ ] Primeiro cenário real
- [ ] NPCs e diálogos
- [ ] Quests básicas
- [ ] Exploração vertical (subsolo)

### 🔮 Phase 4+: Full Vision
Ver [docs/07-producao/roadmap.md](docs/07-producao/roadmap.md)

## 💡 Key Features

### 🎯 Design Highlights

1. **Modular Architecture**
   - Código organizado por domínio
   - Scripts reutilizáveis
   - Fácil manutenção e expansão

2. **Godot Best Practices**
   - Autoload para singletons
   - Signals para comunicação
   - Type hints para segurança
   - @onready para performance

3. **Documentation First**
   - Comentários em português
   - Docs inline (##)
   - READMEs abrangentes

4. **Extensible Structure**
   - Pastas preparadas para crescimento
   - Sistema de eventos flexível
   - Base para sistemas complexos

## 📊 Project Stats

| Métrica | Valor |
|---------|-------|
| **Godot Version** | 4.3+ |
| **Scripts** | 3 (.gd) |
| **Scenes** | 3 (.tscn) |
| **Total Files** | 17 new files |
| **Lines of Code** | ~350 lines |
| **Development Time** | ~20 minutes |
| **Pull Request** | [#1](https://github.com/g0dux/NovaDeva/pull/1) |

## 🔗 Quick Links

| Resource | Link |
|----------|------|
| 🎮 **How to Play** | [PROJETO_GODOT.md](PROJETO_GODOT.md) |
| 📊 **Technical Summary** | [BOOTSTRAP_SUMMARY.md](BOOTSTRAP_SUMMARY.md) |
| ✅ **Verification** | [VERIFICATION_CHECKLIST.md](VERIFICATION_CHECKLIST.md) |
| 📖 **Full Documentation** | [docs/README.md](docs/README.md) |
| 🗺️ **Roadmap** | [docs/07-producao/roadmap.md](docs/07-producao/roadmap.md) |
| 🌍 **World Lore** | [docs/02-mundo-narrativa/mundo-e-lore.md](docs/02-mundo-narrativa/mundo-e-lore.md) |
| 💬 **Pull Request** | [PR #1](https://github.com/g0dux/NovaDeva/pull/1) |

## 🎨 Visual Identity

```
╔══════════════════════════════════════╗
║                                      ║
║          N O V A   D E V A          ║
║                                      ║
║   RPG de Ação em Mundo Aberto       ║
║                                      ║
║   🌍 Sobrevivência Estilo Outward   ║
║   ⚔️  Combate Soulslike              ║
║   🌙 Mundo Fantástico Macabro       ║
║                                      ║
║   Devas na Superfície ☀️            ║
║   Asuras no Subsolo 🌑              ║
║                                      ║
╚══════════════════════════════════════╝
```

## 🛠️ Tech Stack

- **Engine**: Godot 4.3+
- **Language**: GDScript
- **Rendering**: Forward Plus
- **3D Physics**: Built-in Godot physics
- **Version Control**: Git + GitHub
- **Documentation**: Markdown

## 🤝 Contributing

O projeto está na fase de bootstrap. Para contribuir:

1. Revise o [PR #1](https://github.com/g0dux/NovaDeva/pull/1)
2. Consulte a documentação em `docs/`
3. Siga as convenções de código estabelecidas
4. Crie branches com padrão `cursor/<nome>-a22c`

## 📝 License

[A definir]

---

**Status**: ✅ BOOTSTRAP COMPLETO - PROJETO JOGÁVEL  
**Last Update**: 2026-09-12  
**Maintainer**: g0dux  
**Engine**: Godot 4.3+

🎮 **Ready to play! Press F5 in Godot Editor.**
