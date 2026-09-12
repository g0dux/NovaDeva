# Pipeline de Modelos 3D

> Como todo asset 3D é produzido, do concept ao Godot. Seguir este pipeline permite que artistas trabalhem 100% isolados dos sistemas.

## Ferramentas

| Etapa | Ferramenta |
|---|---|
| Concept/paint-over | Krita / Photoshop |
| Modelagem/UV/rig | **Blender 4.x** (padrão do projeto) |
| Escultura de detalhe | Blender sculpt (ZBrush opcional) |
| Texturização | Substance Painter (smart materials do projeto) ou pintura no Blender |
| Export | **glTF 2.0 (.glb)** — nunca FBX |
| Versionamento | Git LFS; fonte .blend em `art_source/` (repo separado ou LFS) |

## Convenções gerais

- Escala real: 1 unidade Blender = 1 m. Player = 1.8 m. Aplicar transforms antes do export (scale 1, rot 0).
- Eixo: Y-up no export glTF (Blender exporta certo por padrão — conferir).
- Nomenclatura: `categoria_nome_variante_LODn` → `wpn_espada1m_ferro_LOD0`, `env_vale_arvore_pinheiro_a`.
- Sufixos de colisão do importer Godot: `-col` (trimesh), `-convcol`, `-colonly` — colliders criados já no Blender para props.
- Pivô: base do objeto (props), entre os pés (personagens), empunhadura (armas).

## Orçamentos de polígonos (tris) e texturas

| Categoria | LOD0 | Texturas |
|---|---|---|
| Player + equipamento visível | 40–60k total | 2k por conjunto de armadura |
| Inimigo comum | 8–15k | 1× 2k atlas |
| Chefe | 30–50k | 2× 2k |
| Arma | 1.5–3k | 1k (atlas de 4 armas quando possível) |
| Prop pequeno (caneca, pote) | 150–500 | atlas compartilhado 2k por kit |
| Prop grande (carroça, estátua) | 2–6k | 2k |
| Módulo de arquitetura | 1–4k | trim sheets (ver abaixo) |
| Vegetação (árvore) | 3–8k + billboards | atlas de folhagem por região |

- **LODs:** gerar LOD automático do Godot (mesh LOD) para a maioria; LODs manuais só para heróis (personagens/chefes). Billboard impostor para árvores distantes.
- **Texel density:** 512 px/m ambiente, 1024 px/m personagens/armas (dobro porque a câmera chega perto).

## Trim sheets e atlas (chave para o estilo)

O visual painterly permite ECONOMIA: 
- 1 **trim sheet** de madeira + 1 de pedra + 1 de metal + 2 de osso ("osso de Deva" pálido e "osso de Asura" escuro/vítreo) por região cobrem 80% da arquitetura.
- Atlases de props por kit (ex.: `kit_cozinha_atlas_2k`).
- Texturas: albedo pintado + normal (bake de sculpt suavizado) + máscara ORM leve. Roughness pouco variada — o estilo vem do albedo.

## Materiais no Godot

- Importar .glb com materiais nomeados → mapear para **materiais Godot compartilhados** em `art/materials/` (external material remap no import). Nunca material embutido duplicado por mesh.
- Shader-base de ambiente e de personagem (ver doc VFX/shaders); variações = parâmetros, não shaders novos.

## Pipeline passo a passo (asset de ambiente)

1. Concept aprovado contra a cena-vitrine da região.
2. Blockout no Blender → testar escala numa cópia da vitrine.
3. Modelagem final + UV (respeitar texel density) + LODs se herói.
4. Textura (smart material do projeto como base + pintura de acentos).
5. Colliders `-col` no Blender.
6. Export .glb para `art/environment/<região>/` com preset de import do projeto.
7. **Validação:** abrir `tests/asset_review.tscn` (cena com iluminação dia/noite das regiões + grid de escala + contador de tris/draw calls) e tirar screenshot para review.

## Pipeline de personagem/criatura

1. Concept com folha de modelo (frente/lado + close do detalhe macabro).
2. Sculpt → retopo dentro do orçamento → bake de normal suave.
3. Rig: **esqueleto humanoide padrão do projeto** (ver doc personagens) para humanoides; rig custom para criaturas (aprovar antes de animar).
4. Skinning: máx 4 bones por vértice.
5. Export .glb COM esqueleto; animações em .glb separado compartilhando o rig (animation libraries no Godot).
6. Validação em `tests/character_review.tscn` (roda ciclo idle/walk/attack com o AnimationTree padrão).

## Checklist de aceite (todo asset)

- [ ] Escala correta contra o boneco de 1.8 m
- [ ] Dentro do orçamento de tris/texturas
- [ ] Sem materiais duplicados; usa shader-base
- [ ] Collider presente e simples (props)
- [ ] Pivô correto, transforms aplicados
- [ ] Lê bem à distância (screenshot 30 m) e à noite
- [ ] Encaixa na cena-vitrine sem destoar
