# Nova Deva - Projeto Godot

RPG de ação em mundo aberto para **Godot 4.x**: sobrevivência estilo [Outward](https://www.outwardgame.com/), combate soulslike e um mundo fantástico mais macabro — Devas na superfície, Asuras no subsolo.

## 🎮 Como Jogar

### Pré-requisitos

- [Godot Engine 4.3+](https://godotengine.org/download) instalado no seu sistema

### Abrindo o Projeto

1. Abra o Godot Engine
2. Clique em "Import" (Importar)
3. Navegue até a pasta raiz deste repositório
4. Selecione o arquivo `project.godot`
5. Clique em "Import & Edit" (Importar e Editar)

### Rodando o Jogo

- Pressione **F5** ou clique no botão ▶️ (Play) no canto superior direito do editor
- Ou selecione `Project > Run` no menu

### Controles

- **WASD** - Movimento do personagem
- **Espaço** - Pular
- **Mouse** - Rotacionar câmera
- **ESC** - Alternar captura do mouse (liberar/capturar cursor)
- **Enter** - Pausar/Despausar

## 📁 Estrutura do Projeto

```
/
├── project.godot          # Arquivo principal do projeto Godot
├── icon.svg              # Ícone do projeto
├── scenes/               # Cenas do jogo
│   ├── main/            # Cena principal
│   │   └── main.tscn    # Cena de teste com player e ambiente
│   ├── player/          # Personagem jogável
│   │   └── player.tscn
│   ├── ui/              # Interface do usuário
│   │   └── hud.tscn
│   └── environment/     # Cenários e ambientes
├── scripts/             # Scripts GDScript
│   ├── autoload/        # Singletons (autoload)
│   │   └── game_manager.gd
│   ├── player/
│   │   └── player.gd
│   ├── ui/
│   │   └── hud.gd
│   └── environment/
├── assets/              # Assets do jogo
│   ├── textures/       # Texturas e sprites
│   ├── models/         # Modelos 3D
│   ├── audio/          # Sons e música
│   └── fonts/          # Fontes
└── docs/               # Documentação do projeto
    ├── 01-visao-geral/ # GDD e visão geral
    ├── 02-mundo-narrativa/
    ├── 03-sistemas/    # Arquitetura e sistemas
    ├── 04-fisica/
    ├── 05-arte/        # Arte e referências visuais
    ├── 06-audio/
    └── 07-producao/    # Roadmap e planejamento
```

## 🚀 Estado Atual

### ✅ Implementado

- Projeto Godot 4.3 configurado
- Estrutura de pastas organizada
- Sistema de autoload (GameManager)
- Personagem jogável com:
  - Movimento WASD em 3D
  - Pulo
  - Câmera em terceira pessoa controlada por mouse
  - Física básica (gravidade, colisão)
- HUD básico com:
  - Título do jogo
  - Instruções de controle
  - Indicador de estado
- Cena de teste com plataformas
- Sistema de pause
- Ambiente 3D básico (skybox, iluminação)

### 🔜 Próximos Passos

A documentação completa do projeto está na pasta `docs/`:

- **Visão Geral**: [docs/01-visao-geral/gdd-visao-geral.md](docs/01-visao-geral/gdd-visao-geral.md)
- **Mundo e Lore**: [docs/02-mundo-narrativa/mundo-e-lore.md](docs/02-mundo-narrativa/mundo-e-lore.md)
- **Arquitetura**: [docs/03-sistemas/00-arquitetura-godot.md](docs/03-sistemas/00-arquitetura-godot.md)
- **Roadmap**: [docs/07-producao/roadmap.md](docs/07-producao/roadmap.md)

## 🛠️ Desenvolvimento

### Convenções de Código

- **Linguagem**: GDScript (padrão Godot)
- **Indentação**: Tabs (padrão Godot)
- **Nomenclatura**:
  - `snake_case` para variáveis e funções
  - `PascalCase` para classes e cenas
  - `UPPER_CASE` para constantes

### Sistema de Autoload

O projeto usa o padrão Singleton através do autoload `GameManager`:

```gdscript
# Acessar de qualquer script:
GameManager.current_state
GameManager.player
```

### Adicionando Novas Mecânicas

1. Crie scripts na pasta `scripts/` correspondente
2. Crie cenas na pasta `scenes/` correspondente
3. Assets vão em `assets/` nas subpastas apropriadas
4. Documente sistemas complexos em `docs/03-sistemas/`

## 📚 Documentação

Para entender a visão completa do projeto, sistemas planejados e direção de arte, consulte a [documentação completa](docs/README.md).

## 🔗 Links

- **Repositório**: https://github.com/g0dux/NovaDeva
- **Godot Engine**: https://godotengine.org/
- **Documentação Godot**: https://docs.godotengine.org/

## 📝 Licença

[A definir]

---

**Desenvolvido com Godot 4.3**
