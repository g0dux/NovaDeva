# Changelog - IA de Inimigos + Inventário & Sobrevivência

**Data**: 2026-09-12  
**Commits**: `c4ce9ff` (IA) + `c1905f6` (Inventário/Sobrevivência)  
**Branch**: `cursor/bootstrap-godot-project-a22c`

## 🎯 Objetivo

Implementar dois pacotes completos de funcionalidades:
1. **Inimigos que atacam de volta** com IA básica
2. **Inventário e sobrevivência** jogáveis

---

## ⚔️ PARTE 1: IA de Inimigos

### Implementação

**AIBrain (FSM):**
- Estados: `IDLE → ALERT → COMBAT → ATTACK → DEAD`
- Detecção: 12m de alcance visual
- Perseguição: Move-se a 3.5 m/s em direção ao player
- Ataque: A cada 2s quando em alcance (2.5m)
- Abandono: Desiste se player se afastar >18m (1.5× detecção)

**EnemyCombatComponent:**
- Similar ao player mas para inimigos
- Dano: 15 (vs 25 do player)
- Alvo: Hurtbox do player (camada 9)
- Ciclo: Windup → Active → Recovery

**Asura Grunt (Inimigo):**
- HP: 75 (morre em 3 hits do player)
- Stamina: 50
- Feedback visual:
  - Idle: Branco
  - Alert: Amarelo (detectou player)
  - Combat/Attack: Vermelho (agressivo)
  - Hit: Flash vermelho
- Morte: Aguarda 2s e desaparece

**Física:**
- Hurtbox inimigo: Camada 7 (player ataca)
- Hurtbox player: Camada 9 (inimigo ataca)

### Resultado
✅ Inimigos detectam player a 12m  
✅ Perseguem e atacam corpo a corpo  
✅ Causam dano no player (15/hit)  
✅ Player pode morrer se não reagir  

---

## 🎒 PARTE 2: Inventário & Sobrevivência

### Sistema de Inventário

**Arquitetura:**
- `ItemData` (Resource): Definição de item
- `InventorySlot`: Gerencia item + quantidade + stacking
- `InventoryComponent`: 20 slots
- `ItemPickup`: Coletáveis no mundo

**Itens Implementados:**

| Item | Efeito | Stack | Localização |
|------|--------|-------|-------------|
| Poção de Cura | +40 HP, +20 Stamina | 5 | 2x no mundo |
| Pão Ressecado | +10 HP, +30 Fome | 10 | 3x no mundo |
| Cantil de Água | +10 Stamina, +50 Sede | 5 | 2x no mundo |

**Uso:**
- **E** para pegar item (quando próximo)
- **I** para abrir/fechar inventário
- **Clicar** no slot para usar item consumível

### Sistema de Sobrevivência

Seguindo `docs/03-sistemas/02-sobrevivencia.md`:

**Necessidades:**

| Necessidade | Decaimento | Penalidade <25% | Penalidade <10% |
|-------------|------------|-----------------|-----------------|
| **Fome** | 1.0/s | Stamina máx −15% | HP máx −20% + tela dessaturada |
| **Sede** | 1.5/s | Regen stamina −20% | Dano de Decay 1/s |

**Características:**
- Decai gradualmente (não instantâneo)
- Penalidades são debuffs, não morte imediata
- Sede crítica causa dano contínuo (simulando desidratação)
- Comida restaura fome, água restaura sede
- Poções curam HP e stamina

### HUD Completo

**4 Barras de Status:**
1. **HP** (Vermelho) - Vida do player
2. **Stamina** (Amarelo) - Energia para ações
3. **Fome** (Laranja) - Necessidade de comida
4. **Sede** (Azul) - Necessidade de água

**Painel de Inventário:**
- Grid 5×4 (20 slots)
- Mostra nome e quantidade
- Slots vazios desabilitados
- Clicar usa item consumível

**Controles Atualizados:**
- WASD - Movimento
- Espaço - Pular
- Clique Esquerdo - Atacar
- **E - Pegar item** (novo)
- **I - Abrir inventário** (novo)
- ESC - Mouse

---

## 📊 Estatísticas

### Commit 1 (IA):
- **Arquivos novos**: 4 scripts + 1 cena
- **Arquivos modificados**: 2
- **Linhas de código**: ~450

### Commit 2 (Inventário/Sobrevivência):
- **Arquivos novos**: 10 scripts/cenas + 3 recursos de itens
- **Arquivos modificados**: 4
- **Linhas de código**: ~768

### Total:
- **Arquivos criados**: 18
- **Linhas de código**: ~1,200
- **Componentes**: 7 novos (AIBrain, EnemyCombat, Item, Inventory, Survival, etc)
- **Tempo de desenvolvimento**: ~90 minutos

---

## ✅ Critérios de Sucesso

### Inimigos:
✅ Inimigo agride o player automaticamente  
✅ Player pode morrer se não reagir  
✅ Player pode matar inimigos  
✅ Feedback visual claro (cores de estado)  

### Inventário & Sobrevivência:
✅ Player abre inventário (I)  
✅ Player pega itens (E)  
✅ Player usa itens (cura/comida/água)  
✅ Fome/Sede drenam com o tempo  
✅ Penalidades perceptíveis (barra vermelha, dano)  
✅ HUD reflete todos os recursos  

### Geral:
✅ Código limpo com type hints  
✅ Componentes reutilizáveis  
✅ Sem pause/freeze reintroduzido  
✅ Combate melee preservado  
✅ Tudo integrado no mesmo PR  

---

## 🎮 Como Testar

1. **Abra o projeto no Godot 4.3+**
2. **Pressione F5**

### Teste de Combate com IA:
1. Mova-se em direção aos Asura Grunts (8m à frente)
2. Observe os inimigos ficarem amarelos (alerta) a 12m
3. Eles perseguem e ficam vermelhos (combate)
4. Atacam a cada 2s (você toma 15 de dano)
5. Ataque de volta (clique esquerdo) para matá-los

### Teste de Inventário:
1. Aproxime-se dos itens (cubos coloridos perto do spawn)
2. Pressione **E** quando o label ficar verde
3. Itens vão para o inventário
4. Pressione **I** para abrir inventário
5. Clique em um item para usar

### Teste de Sobrevivência:
1. Aguarde ~30 segundos
2. Observe barras de Fome e Sede caindo
3. Quando Sede <10%, você toma dano contínuo
4. Use água (cantil) para restaurar sede
5. Use pão para restaurar fome

### Teste Integrado:
1. Lute contra inimigos (perde HP)
2. Fique parado (perde Fome/Sede)
3. Pegue itens e use poção para curar
4. Use água/comida para manter necessidades
5. Continue lutando

---

## 🚀 Arquitetura

### Camadas de Física Utilizadas

| Camada | Nome | Uso Atual |
|--------|------|-----------|
| 1 | world_static | Chão e plataformas |
| 2 | player_body | Corpo do player |
| 3 | enemy_body | Corpo de inimigos |
| 6 | hitbox_player | Ataques do player |
| 7 | hurtbox_enemy | Inimigos podem ser atingidos |
| 8 | hitbox_enemy | Ataques de inimigos |
| 9 | hurtbox_player | Player pode ser atingido |
| 11 | interaction | Pickups de itens |

### Componentes Reutilizáveis

**StatsComponent** → Usado por player E inimigos  
**CombatComponent** → Versão player + versão enemy  
**InventoryComponent** → Modular, pode ir em NPCs  
**SurvivalComponent** → Modular, expansível (sono, temperatura)  

---

## 📝 Próximas Expansões Sugeridas

### Curto Prazo:
- [ ] Animações de ataque (player e inimigo)
- [ ] Sons de combate e impacto
- [ ] Mais tipos de inimigos (variações)
- [ ] Loot drops de inimigos mortos

### Médio Prazo:
- [ ] Sono (3ª necessidade de sobrevivência)
- [ ] Temperatura (4ª necessidade)
- [ ] Crafting básico
- [ ] Equipamentos (armas/armaduras)
- [ ] Save/Load system

### Longo Prazo:
- [ ] IA avançada (patrulha, furtividade, alerta de grupo)
- [ ] Sistema de status effects (doenças, buffs)
- [ ] Sistema de fogueira e acampamento
- [ ] Mundo aberto com zonas climáticas

Consulte os design docs completos em `docs/` para a visão de longo prazo.

---

## 🔗 Links

- **PR**: https://github.com/g0dux/NovaDeva/pull/1
- **Commits**: 
  - IA: `c4ce9ff`
  - Inventário: `c1905f6`
- **Design Docs**:
  - IA: `docs/03-sistemas/06-ia-inimigos.md`
  - Sobrevivência: `docs/03-sistemas/02-sobrevivencia.md`
  - Combate: `docs/03-sistemas/01-combate.md`

---

**Status**: ✅ Completo e Testável  
**Pronto para**: Testar no Godot Editor  
**Próximo**: Feedback do usuário e iteração
