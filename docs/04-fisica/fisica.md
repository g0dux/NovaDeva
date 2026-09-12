# Física do Jogo

> Física a serviço do "peso" soulslike: personagens com inércia, impactos com resposta, mundo estável e previsível. Nada de física caótica de simulação — controle autoral com toques de simulação onde vende impacto.

## Engine de física

- **Jolt Physics** (built-in no Godot 4.4+): mais estável e performática que a GodotPhysics padrão para personagens + muitos corpos.
- `physics_ticks_per_second = 60`. Combate depende de timing; não baixar.

## Camadas de colisão (contrato global)

| # | Camada | Colide com |
|---|---|---|
| 1 | `world_static` | tudo |
| 2 | `player_body` | 1,3,4,5,10 |
| 3 | `enemy_body` | 1,2,3,5,10 |
| 4 | `npc_body` | 1,2,10 |
| 5 | `projectile` | 1,2,3 (por máscara do dono) |
| 6 | `hitbox_player` | 7 |
| 7 | `hurtbox_enemy` | 6 |
| 8 | `hitbox_enemy` | 9 |
| 9 | `hurtbox_player` | 8 |
| 10 | `props_dynamic` | 1,2,3,4,10 |
| 11 | `interaction` | (raycast do player) |
| 12 | `climate_zone`/`trigger` | (áreas — sem colisão física) |

Hitbox/hurtbox separados de corpos físicos: dano NUNCA depende de colisão de corpo (precisão + performance).

## Movimento do jogador (MovementComponent)

`CharacterBody3D` + `move_and_slide()`, com aceleração/desaceleração explícitas (nada de velocidade instantânea — peso):

| Parâmetro | Valor inicial |
|---|---|
| Velocidade andar / correr / sprint | 2.0 / 4.5 / 7.0 m/s |
| Aceleração / freio | 12 / 16 m/s² |
| Rotação do personagem | 10 rad/s (lerp para direção do input) |
| Gravidade | 14 m/s² (mais que 9.8 — pulos "de jogo") |
| Pulo | 1.1 m de altura; só sem sobrepeso |
| Coyote time / jump buffer | 0.12 s / 0.15 s |
| Rampa máxima | 42°; acima escorrega |
| Degrau automático | até 0.35 m sem pulo |

- **Modificadores**: classe de peso, sobrepeso, status (Hypothermia etc.) multiplicam velocidade/aceleração via sistema de modificadores do StatsComponent.
- **Roll/esquiva**: movimento por root motion da animação (não impulso físico) → distância consistente = balanceável.
- **Queda**: dano a partir de 4 m, quadrático; > 8 m aplica Ferida Aberta; > 12 m derrota (cenário).
- Água: até o joelho = lento + molhado (sobrevivência); nado simples na superfície; sem combate nadando (guardar armas).

### Câmera
- Terceira pessoa: `SpringArm3D` (3.5 m, colide com `world_static`), pivô na altura do ombro, FOV 65.
- Lock-on move o pivô para o ponto médio jogador↔alvo com clamps.

## Knockback, stagger e impacto

- Knockback é **deslocamento controlado** (tween/velocity aplicada no CharacterBody), não impulso de rigid body — previsível para o combate.
- Impacto "vendido" por: hitstop (60–120 ms de freeze local nos dois), shake leve de câmera, partícula, som. Física real só no ragdoll.

## Ragdoll (morte)

- `PhysicalBoneSimulator3D` no esqueleto padrão; ativado na morte com a velocity do golpe final injetada no bone atingido.
- Ragdolls dormem em 3 s e viram estáticos; máx 6 ragdolls ativos (fila remove os antigos).
- Cadáver saqueável usa a pose final (collider simples por cima — nunca raycast contra physical bones).

## Props e objetos dinâmicos

- Destrutíveis leves (potes, caixas): `RigidBody3D` em `props_dynamic`, trocados por versão quebrada + peças com timer de despawn 10 s.
- Itens no chão: RigidBody que dorme rápido e congela (`freeze = true`) após pousar.
- Objetos de puzzle físico (raro): plataformas/contrapesos com `AnimatableBody3D` — animação autoral, não simulação.
- Orçamento: ≤ 32 rigid bodies acordados simultâneos por região.

## Projéteis

- Flechas/magias: `Area3D` + integração manual (posição += vel·dt; vel.y −= g·dt para flechas). Raycast entre frames (contínuo) para não atravessar em alta velocidade.
- Flechas fincam onde acertam (reparent + freeze) e são coletáveis (economia de munição).

## Navegação vs. física

- IA usa `NavigationAgent3D`; avoidance ligado apenas em combate em grupo.
- Navmesh bake offline por região; obstáculos dinâmicos grandes usam `NavigationObstacle3D`.

## Performance

- Colliders do mundo: primitivos e convex hulls; trimesh (concave) apenas para terreno/estruturas estáticas grandes.
- Áreas de clima/trigger em camada 12 sem monitorable desnecessário.
- Perfilar com o monitor `Physics Process` do Godot; alvo ≤ 3 ms/frame de física na região mais densa.

## Gym

`tests/physics_gym.tscn`: rampas de todos os ângulos, escadas de degraus variados, poço de queda graduado, piscina, 40 rigid bodies, dummy de knockback e botão de ragdoll. Toda mudança no MovementComponent é validada aqui antes de ir para o mundo.
