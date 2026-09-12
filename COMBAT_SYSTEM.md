# Sistema de Combate - Implementação Atual

## ✅ Status: Sistema Básico Jogável

O sistema de combate corpo a corpo está implementado e funcional, seguindo as diretrizes do documento de design em `docs/03-sistemas/01-combate.md`.

## 🎮 Como Usar

### Controles
- **Botão Esquerdo do Mouse** - Atacar corpo a corpo
- O ataque consome **15 de stamina**
- Stamina regenera automaticamente após 0.8s sem gastar

### Mecânicas Implementadas

#### Player
- **HP**: 100 (regenera com comida/poções - a implementar)
- **Stamina**: 100 (regenera 25/s após delay de 0.8s)
- **Ataque**: 25 de dano, alcance 2m, custo 15 stamina
- **Feedback visual**: Flash vermelho ao tomar dano
- **Morte**: Player para de se mover ao morrer

#### Inimigos (Dummy)
- **HP**: 100
- **Feedback visual**: Flash vermelho ao tomar dano
- **Label 3D**: Mostra HP atual acima da cabeça
- **Morte**: Dummy desaparece após 0.5s

#### HUD
- **Barra de HP**: Verde, mostra HP atual/máximo
- **Barra de Stamina**: Amarela, mostra stamina atual/máximo
- **Labels**: Valores numéricos sobre as barras
- **Atualização em tempo real**: Conectado aos signals do StatsComponent

## 📁 Arquitetura

### Componentes

```
scripts/combat/
├── damage_info.gd          # Classe de dados para dano
├── stats_component.gd      # HP/Stamina (reutilizável)
└── combat_component.gd     # Lógica de ataque do player
```

### Cenas

```
scenes/
├── enemy/
│   └── enemy_dummy.tscn    # Alvo de teste
├── ui/
│   └── combat_hud.tscn     # HUD de combate
└── player/player.tscn      # Player com componentes
```

### Camadas de Física

Implementadas conforme `docs/04-fisica/fisica.md`:

| Camada | Nome | Uso |
|--------|------|-----|
| 1 | world_static | Mundo estático |
| 2 | player_body | Corpo do player |
| 3 | enemy_body | Corpo de inimigos |
| 6 | hitbox_player | Hitbox de ataques do player |
| 7 | hurtbox_enemy | Hurtbox de inimigos |
| 8 | hitbox_enemy | Hitbox de ataques de inimigos |
| 9 | hurtbox_player | Hurtbox do player |

## 🎯 Pipeline de Dano

Implementação simplificada do pipeline do design doc:

1. **CombatComponent** detecta hitbox do player via `intersect_shape`
2. Verifica colisão com **camada 7** (hurtbox_enemy)
3. Cria **DamageInfo** com:
   - amount (dano)
   - damage_type (tipo de dano)
   - poise_damage (dano de postura)
   - source (quem atacou)
4. **StatsComponent** do alvo recebe o dano
5. Emite signals: `damaged`, `health_changed`, `died`
6. UI e feedback visual escutam os signals

## 🔧 Componentes Detalhados

### DamageInfo (RefCounted)
```gdscript
var amount: float              # Quantidade de dano
var damage_type: StringName    # "slash", "blunt", "pierce", etc
var poise_damage: float        # Dano de postura (não usado ainda)
var knockback: Vector3         # Knockback (não usado ainda)
var source: Node               # Quem causou o dano
```

### StatsComponent (Node)
```gdscript
# Estatísticas
@export var max_health: float
@export var max_stamina: float
@export var stamina_regen_rate: float
@export var stamina_regen_delay: float

# Signals
signal health_changed(current, maximum)
signal stamina_changed(current, maximum)
signal died()
signal damaged(amount, damage_type)

# Métodos principais
func apply_damage(info: DamageInfo) -> bool
func consume_stamina(amount: float) -> bool
func heal(amount: float) -> void
```

### CombatComponent (Node)
```gdscript
# Configuração
@export var attack_damage: float
@export var attack_stamina_cost: float
@export var attack_duration: float
@export var attack_range: float

# Estados
enum State { IDLE, ATTACK_WINDUP, ATTACK_ACTIVE, ATTACK_RECOVERY }

# Signals
signal attack_started()
signal attack_hit(target)

# Métodos principais
func try_attack() -> bool        # Tenta iniciar ataque
func is_attacking() -> bool      # Verifica se está atacando
```

## 🚀 Próximas Expansões

### Curto Prazo
- [ ] Animações de ataque (placeholder ou básicas)
- [ ] Som de ataque e impacto
- [ ] Knockback no inimigo
- [ ] Combo de 2-3 ataques
- [ ] Inimigo que ataca de volta

### Médio Prazo
- [ ] Sistema de poise (postura/stagger)
- [ ] Esquiva (roll) com i-frames
- [ ] Bloqueio com escudo
- [ ] Diferentes tipos de arma
- [ ] Sistema de lock-on

### Longo Prazo
- [ ] Parry e riposte
- [ ] Classes de peso (leve/médio/pesado)
- [ ] Durabilidade de armas
- [ ] Sistema completo de tipos de dano
- [ ] IA de inimigos

## 📊 Tuning Atual

| Parâmetro | Valor | Nota |
|-----------|-------|------|
| Player HP | 100 | Base |
| Player Stamina | 100 | Base |
| Ataque Dano | 25 | Dummy morre em 4 hits |
| Ataque Custo | 15 stamina | ~6 ataques consecutivos |
| Ataque Alcance | 2m | Médio alcance |
| Ataque Duração | 0.6s | Tempo total da animação |
| Stamina Regen | 25/s | ~4s para recarregar tudo |
| Stamina Delay | 0.8s | Após qualquer gasto |

## 🧪 Como Testar

1. Abra o projeto no Godot 4.3+
2. Pressione F5
3. Aproxime-se dos dummies (cápsulas brancas)
4. Clique com botão esquerdo para atacar
5. Observe:
   - Stamina diminui ao atacar
   - Dummy fica vermelho ao ser atingido
   - HP do dummy diminui (label acima)
   - Dummy desaparece ao chegar em 0 HP
   - Stamina regenera após parar de atacar

## ⚠️ Limitações Conhecidas

- **Sem animações**: Ataque é instantâneo
- **Hitbox esférica**: Não acompanha movimento da arma
- **Sem feedback sonoro**: Apenas visual
- **Dummy estático**: Não se move nem contra-ataca
- **Sem invencibilidade**: Player sempre pode ser atingido (quando implementarmos ataques inimigos)

## 🔗 Referências

- Design completo: `docs/03-sistemas/01-combate.md`
- Física e camadas: `docs/04-fisica/fisica.md`
- Arquitetura: `docs/03-sistemas/00-arquitetura-godot.md`

---

**Implementado**: 2026-09-12  
**Commit**: `b09a465`  
**Branch**: `cursor/bootstrap-godot-project-a22c`
