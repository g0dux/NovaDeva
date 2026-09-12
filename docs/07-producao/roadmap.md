# Roadmap de Produção

> Ordem de construção pensada para validar o risco maior primeiro (o combate tem que ser bom; a sobrevivência tem que ser divertida) e permitir trabalho paralelo por módulo.

## Fase 0 — Fundação (semanas 1–4)

**Objetivo: projeto Godot com a arquitetura do doc 00 funcionando.**
- [ ] Projeto Godot 4.x, pastas, Git+LFS, presets de import
- [ ] Autoloads: EventBus (contrato v1), GameState, DataRegistry, WorldClock
- [ ] StatsComponent + sistema de modificadores
- [ ] MovementComponent + câmera no `physics_gym` (capsula, greybox)
- [ ] Gyms vazios de cada sistema criados

**Gate:** andar/correr/pular/rolar com feel aprovado em greybox.

## Fase 1 — Vertical Slice de combate (semanas 5–12)

**Objetivo: 10 minutos de combate que já parecem Nova Deva.**
- [ ] Combate: FSM, stamina, pipeline de dano, hitboxes por animação, lock-on, parry/bloqueio
- [ ] 1 arma (espada 1M) com moveset autoral animado
- [ ] IA: Fera (Lobo Pálido) + humanoide (Cultista) com percepção e tokens
- [ ] Arte: player rig v1, os 2 inimigos, shader-base de personagem
- [ ] Áudio: golpes/parry/passos provisórios; 1 stem-set de combate

**Gate (o mais importante do projeto):** playtest externo diz que o combate é "bom e justo". NÃO avançar sem isso.

## Fase 2 — Loop de sobrevivência (semanas 13–20)

**Objetivo: expedição completa de 30 min em área de teste.**
- [ ] Sobrevivência: 4 necessidades, temperatura com ClimateZones, status effects, HP queimado
- [ ] Inventário: peso, mochila largável, equipamento, durabilidade
- [ ] Crafting: fogueira/cozinha + bancada de campo; 20 receitas
- [ ] Acampamento/dormir com alocação de horas; WorldClock dia/noite visual
- [ ] Save/load v1 (round-trip completo)
- [ ] Cenários de derrota v1 (2 cenários)

**Gate:** tester faz preparar→viajar→dungeon greybox→voltar e quer jogar de novo.

## Fase 3 — Região 1 completa (semanas 21–36)

**Objetivo: Vale Vertebral jogável do início ao fim.**
- [ ] Kit de arte da região + cena-vitrine aprovada → greybox da região → dressing
- [ ] Solva (cidade), 3 dungeons, POIs pela tabela de densidade
- [ ] 8 tipos de inimigo + chefes 1–2; Caçada Pálida (evento)
- [ ] Magia: escolas Cinzas + Mortalha, sigilos, combinação, Altar de Medula, corrupção
- [ ] Progressão: 3 árvores de skill (Mercenário, Cinzas, Mortalha), economia v1
- [ ] Quests: sistema completo + 8 quests da região (2 com timer)
- [ ] Trilha: tema principal + stems da região 1 + música adaptativa funcionando
- [ ] Ambiência completa da região 1

**Gate:** 6–8h de jogo coeso; "demo Steam" possível daqui.

## Fase 4 — Regiões 2 e 3 (semanas 37–60)

- [ ] Cinzas de Ombra (temperatura extrema como mecânica central da região)
- [ ] Lamento Submerso (água/doença/áudio-horror como mecânica central)
- [ ] Escolas Víscera + Eco; árvores restantes; chefes 3–7
- [ ] Linhas de facção (3× 8 quests) + escolha exclusiva
- [ ] Caravanas, atalhos inter-região, contratos repetíveis

## Fase 5 — Final e polimento (semanas 61–76)

- [ ] Ato final: câmara da Nova Deva, chefe final por facção, 3 finais
- [ ] Passe de balanceamento global (economia, dano, sobrevivência)
- [ ] Passe de performance (orçamentos dos docs), passe de acessibilidade (remapear controles, tamanho de fonte, opções de câmera)
- [ ] Localização EN; QA de save/migração; soak tests
- [ ] Beta fechado → correções → lançamento

## Trabalho paralelo (quem não bloqueia quem)

```
Programação sistemas ──► gyms (nunca esperam arte)
Arte de personagens  ──► character_review.tscn (nunca espera código)
Arte de ambiente     ──► cenas-vitrine (espera só greybox do level design)
Áudio/trilha         ──► audio_gym + capturas (espera só o contrato de sinais)
Narrativa/quests     ──► planilhas + .dialogue (espera sistema de quest da fase 3)
```

## Riscos principais

| Risco | Mitigação |
|---|---|
| Combate não ficar bom | Gate duro na fase 1; é o único item sem plano B |
| Escopo de 3 regiões | Região 3 é a cortável (mundo fecha com 2 + ato final) |
| Música adaptativa custosa | Fallback: crossfade simples por estado (perde elegância, não conteúdo) |
| Sobrevivência chata | Regra anti-tédio do doc 02; taxas em .tres para ajuste rápido |
| Solo/equipe pequena | Todos os docs assumem placeholders e módulos independentes — nada bloqueia nada |
