# Sistema de Magia e Rituais

> Magia em Nova Deva é **perigosa, preparada e combinatória** — inspirada no sistema de Outward (sigilos + combinações) levada ao tom macabro: toda magia é fazer o que as Devas faziam — **controlar a Ressonância, a energia corrompida dos Asuras** — em escala humana. E usá-la deixa marcas.

## Princípios

1. **Magia não é padrão.** O jogador começa sem mana. Para obtê-la, troca permanentemente HP e stamina máximos por **Ressonância** em um Altar de Medula — um altar construído sobre medula exposta de **Asura** (decisão irreversível, cerimônia perturbadora: você deixa a energia deles entrar).
2. **Magia é preparada.** As magias fortes exigem componentes, sigilos no chão ou condições (noite, chuva, estar corrompido).
3. **Magia é combinatória.** Efeitos simples se combinam produzindo efeitos maiores — o conhecimento do jogador é a progressão real.
4. **Magia cobra.** Uso intenso acumula **Corrupção Ressonante** (ver sobrevivência).

## Recurso: Ressonância

- Barra azul-pálida; regenera MUITO devagar sozinha; recupera com: descanso, poções de medula, ficar em zonas de Ressonância (que também corrompem — risco/recompensa).
- Custo típico: magia simples 15–25%, sigilo 30%, ritual 50%+.

## As 4 Escolas (v1.0)

Cada escola é ensinada por um mestre-NPC de uma facção/região (compra com dinheiro + quest, estilo Outward).

### 1. Cinzas (fogo/entropia) — Forja-Vigília
- `Faísca` (projétil fraco), `Sigilo de Brasa` (círculo no chão), `Sopro de Fornalha` (cone).
- **Combinações:** projétil através do sigilo → bola de fogo; arma no sigilo → arma flamejante.

### 2. Mortalha (frio/silêncio) — Ordem do Sepulcro
- `Toque Sepulcral` (melee frost), `Sigilo de Gelo`, `Mortalha` (buff: inimigos te detectam menos).
- **Combinações:** sigilo + chuva → nevasca local; Mortalha + backstab → execução silenciosa.

### 3. Víscera (sangue/carne) — Coro das Vísceras
- Custa **HP em vez de Ressonância**. `Agulha de Sangue`, `Banquete` (cura consumindo cadáver — macabro), `Pele de Tendão` (armadura viva temporária).
- **Combinações:** Banquete em Ressonante → cura + corrupção; Agulha em sangrando → detonação.

### 4. Eco (Ressonância pura, "a arte dos Asuras") — proibida, achada no mundo
- Aprendida em tomos escondidos nas profundezas, não vendida — é usar a energia Asura SEM as correntes que as Devas usavam. `Grito do Asura` (stagger AoE), `Passo de Eco` (teleporte curto que deixa clone-isca), `Pergunta` (um cadáver de gigante responde UMA pergunta — usada em quests).
- Toda magia de Eco adiciona corrupção. Com corrupção > 50, magias de Eco custam menos (a espiral do abismo).

## Sigilos e combinação — regras de sistema

```
Sigilo no chão (Area3D, dura 60s, visível para inimigos)
  + projétil elemental compatível  → efeito amplificado
  + jogador dentro ao castar buff  → versão maior do buff
  + clima/hora compatível          → modificador extra
```

Implementação: cada `SpellData` tem `tags_in` (o que ela procura) e `tags_out` (o que ela oferece). O `SpellcastComponent` resolve interações consultando uma **tabela de combinação** (`data/spell_combos.tres`) — nada hardcodado por par, para escalar combinatória.

## Rituais (magia de mundo)

Rituais são "crafting mágico" no mundo: itens dispostos em círculo + canalização longa (vulnerável) + condição.

| Ritual | Componentes | Efeito |
|---|---|---|
| Vela dos Perdidos | vela de sebo + osso | marca caminho de volta (breadcrumbs luminosos, já que não há fast travel) |
| Purificação | água fervida + sal + noite | remove corrupção (parte em quest também) |
| Chamado Menor | carne fresca + sigilo | atrai/distrai criaturas da região |
| Vigília | ossocarvão na fogueira | dormir sem risco de emboscada 1 noite |

Emite `EventBus.ritual_completed` — quests e mundo escutam (ex.: certo ritual em certo lugar abre segredo).

## Implementação em Godot

- `SpellData extends Resource`: id, escola, custo, cast_time, animação, cena de projétil/efeito, tags, corrupção gerada.
- `SpellcastComponent` (player e alguns inimigos): valida custo → toca animação de casto (cancelável ao sofrer dano = magia perdida) → instancia efeito.
- Projéteis: `Area3D` + movimento manual em `_physics_process` (não RigidBody — previsibilidade), camada de física própria (ver doc física).
- Sigilos: cena com `Area3D` + `Decal` + partículas; registra-se num grupo `"sigils"` para queries de combinação.
- Ritual: cena `RitualCircle` que valida itens do inventário via EventBus request/response.
- VFX desacoplados: o componente emite `spell_cast`; o módulo de VFX escuta e instancia (arte substituível sem tocar em lógica).
- Gym: `tests/magic_gym.tscn` com todos os sigilos, dummies com resistências variadas e toggle de clima.

## Balanceamento

- Um "mago puro" deve ser viável mas frágil e dependente de preparação (carregar componentes pesa na mochila).
- Custo de oportunidade real: cada ponto de Ressonância comprado = −5 HP máx e −3 stamina máx.
- Corrupção: nunca só punição. Cada faixa (25/50/75) dá um trade: +dano mágico / custos menores de Eco / NPCs hostis + visual macabro do personagem.
