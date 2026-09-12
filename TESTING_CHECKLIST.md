# ✅ Checklist Final - Teste do Projeto após Correção de Tipos

## 🎯 Objetivo

Verificar que a correção de inferência de tipos resolveu o erro de parser sem quebrar nenhuma funcionalidade do jogo.

## 📋 Checklist de Abertura do Projeto

### 1. Abrir o Projeto no Godot 4.3+

- [ ] Abrir o Godot Editor
- [ ] Selecionar "Importar" ou "Abrir Projeto"
- [ ] Navegar até a pasta `NovaDeva`
- [ ] Clicar em "Importar & Editar"

**Resultado esperado:**
✅ O projeto deve abrir sem erros de parser  
✅ Não deve aparecer "Parser Error: The variable type is being inferred from a Variant value"  
✅ A cena `scenes/main/main.tscn` deve estar carregada

---

### 2. Verificar Console de Erros

- [ ] Abrir a aba "Output" (Saída) no editor
- [ ] Verificar se há erros ou warnings

**Resultado esperado:**
✅ Nenhum erro de tipo ou parser  
✅ Nenhum warning de inferência de tipo  
⚠️ Avisos de "Node not found" podem aparecer até a cena rodar (normal)

---

### 3. Rodar o Jogo (F5)

- [ ] Pressionar F5 ou clicar em "Play" (▶️)
- [ ] Aguardar o jogo iniciar

**Resultado esperado:**
✅ Jogo inicia sem erros  
✅ Cena 3D carrega com:
  - Chão (plano verde)
  - Player (cubo branco)
  - 3x Asura Grunts (cubos brancos)
  - 3x Itens coletáveis (Poção, Pão, Água)
✅ HUD aparece com 4 barras (HP, Stamina, Fome, Sede)

---

## 🎮 Checklist de Funcionalidades

### A. Movimento do Player

- [ ] **W** - Mover para frente
- [ ] **S** - Mover para trás
- [ ] **A** - Mover para esquerda
- [ ] **D** - Mover para direita
- [ ] **Espaço** - Pular
- [ ] **Mouse** - Rotacionar câmera
- [ ] **ESC** - Toggle captura de mouse

**Resultado esperado:**
✅ Player se move suavemente em todas as direções  
✅ Pulo funciona quando no chão  
✅ Câmera segue o mouse quando capturado  
✅ ESC libera/captura o mouse

---

### B. Sistema de Combate

- [ ] Aproximar de um inimigo (Asura Grunt)
- [ ] **Clicar com botão esquerdo** para atacar
- [ ] Observar o inimigo recebendo dano
- [ ] Observar flash vermelho no inimigo
- [ ] Continuar atacando até o inimigo morrer

**Resultado esperado:**
✅ Ataque funciona (animação de swing invisível por 0.5s)  
✅ Inimigo fica vermelho ao ser atingido  
✅ Label 3D do inimigo mostra HP diminuindo  
✅ Inimigo morre após ~3-4 ataques (75 HP / 25 dano)  
✅ Inimigo desaparece após 2s da morte

---

### C. IA de Inimigos

- [ ] Aproximar de um inimigo (dentro de 12m)
- [ ] Observar o inimigo mudando de cor (branco → amarelo)
- [ ] Aguardar o inimigo se aproximar
- [ ] Observar o inimigo atacando (cor vermelho)
- [ ] Verificar se o player recebe dano

**Resultado esperado:**
✅ Inimigo detecta player (12m) e fica amarelo  
✅ Inimigo persegue o player  
✅ Inimigo ataca quando próximo (2.5m)  
✅ Inimigo fica vermelho durante ataque  
✅ Player recebe 15 de dano por hit  
✅ Barra de HP do player diminui

---

### D. Sistema de Inventário

- [ ] Aproximar de um item coletável (Poção, Pão ou Água)
- [ ] Label 3D do item fica verde
- [ ] Pressionar **E** para coletar
- [ ] Item desaparece
- [ ] Console mostra "Coletou: [nome] x1"
- [ ] Pressionar **I** para abrir inventário
- [ ] Verificar item no grid

**Resultado esperado:**
✅ Detecção de proximidade funciona (label verde)  
✅ Coleta funciona com E  
✅ Item é adicionado ao inventário  
✅ Inventário abre/fecha com I  
✅ Mouse fica visível quando inventário aberto  
✅ Item aparece no grid 4x5

---

### E. Uso de Itens

Com o inventário aberto:

- [ ] **Clicar em um slot de Poção de Cura**
  - HP aumenta em +40
  - Stamina aumenta em +20
- [ ] **Clicar em um slot de Pão**
  - HP aumenta em +10
  - Fome aumenta em +30
- [ ] **Clicar em um slot de Água**
  - Stamina aumenta em +10
  - Sede aumenta em +50

**Resultado esperado:**
✅ Itens são consumidos (quantidade diminui)  
✅ Efeitos são aplicados corretamente  
✅ Barras de stats atualizam visualmente  
✅ Slots vazios ficam desabilitados

---

### F. Sistema de Sobrevivência

- [ ] Observar as barras de **Fome** e **Sede** decaindo gradualmente
- [ ] Aguardar Fome cair abaixo de 25%
- [ ] Aguardar Sede cair abaixo de 25%
- [ ] Aguardar Sede cair abaixo de 10%
- [ ] Verificar se player recebe dano contínuo

**Resultado esperado:**
✅ Fome decai a 1.0/segundo  
✅ Sede decai a 1.5/segundo (mais rápido)  
✅ Penalidades aplicadas quando < 25%  
✅ Dano contínuo quando Sede < 10%  
✅ Player pode morrer de sede se não beber água

---

### G. Morte do Player

- [ ] Deixar inimigos atacarem até HP chegar a 0
- [ ] Observar mensagem "Player morreu!" no console

**Resultado esperado:**
✅ Player morre quando HP = 0  
✅ Mensagem aparece no console  
⚠️ (Futura implementação: tela de game over)

---

## 🐛 Verificações de Bugs Conhecidos

### Issues Corrigidas

- [x] ✅ Parser Error de inferência de tipo (linha 36 em stats_component.gd)
- [x] ✅ Todas as variáveis `:=` substituídas por tipos explícitos
- [x] ✅ Sistema de pause removido (não fazia sentido)

### Verificar se NÃO aparecem:

- [ ] ❌ "Parser Error: The variable type is being inferred from a Variant value"
- [ ] ❌ Warnings de inferência de tipo
- [ ] ❌ Erros de "Node not found" durante o jogo (só ao abrir o projeto é normal)
- [ ] ❌ Crashes ou travamentos
- [ ] ❌ Inimigos não atacando
- [ ] ❌ Itens não coletáveis
- [ ] ❌ Inventário não abrindo

---

## 📊 Resultados

### ✅ Testes Passaram

Marque aqui se todos os testes acima passaram:

- [ ] Projeto abre sem erros
- [ ] Movimento funciona
- [ ] Combate funciona
- [ ] IA funciona
- [ ] Inventário funciona
- [ ] Sobrevivência funciona
- [ ] Sem bugs conhecidos

### ❌ Se Houver Problemas

Documente aqui:

1. **Tipo de erro:**
2. **Quando ocorre:**
3. **Console output:**
4. **Screenshots/videos:**

---

## 📝 Notas Adicionais

### Comportamentos Esperados (não são bugs)

- Player pode morrer se não comer/beber
- Inimigos são agressivos e perseguem
- Fome/Sede decaem constantemente (realista)
- Sem animações 3D (ainda não implementado)
- HUD é básico/funcional (placeholder)

### Performance Esperada

- **FPS:** 60+ (cena é muito simples)
- **Memória:** <100 MB
- **Carregamento:** <2 segundos

---

## 🚀 Próximos Passos (se tudo estiver OK)

Se todos os testes passaram:

1. ✅ Marcar PR #1 como "Ready for Review" (sair de draft)
2. 🎨 Adicionar animações (próxima feature)
3. 💾 Implementar sistema de save/load
4. 🎨 Melhorar HUD (UI mais bonita)
5. 🗺️ Adicionar mais áreas/cenários
6. 👹 Criar mais tipos de inimigos

---

**Data de criação:** 2026-09-12  
**Versão testada:** Bootstrap Completo  
**Branch:** `cursor/bootstrap-godot-project-a22c`  
**Commits principais:**
- `51878a5` - docs: Add comprehensive documentation index
- `f057f3c` - fix: Corrige inferência de tipos Variant em todos os scripts
