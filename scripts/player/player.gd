extends CharacterBody3D
## Player Controller - Movimento, combate, inventário e sobrevivência
##
## Controlador completo do personagem:
## - WASD para movimento
## - Space para pular
## - Mouse para rotação da câmera
## - Botão esquerdo do mouse para atacar
## - E para interagir
## - I para abrir inventário

const SPEED := 5.0
const JUMP_VELOCITY := 4.5
const MOUSE_SENSITIVITY := 0.002

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var combat: CombatComponent = $CombatComponent
@onready var stats: StatsComponent = $StatsComponent
@onready var inventory: InventoryComponent = $InventoryComponent
@onready var survival: SurvivalComponent = $SurvivalComponent
@onready var mesh: MeshInstance3D = $MeshInstance3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var hit_flash_timer: float = 0.0


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.player = self
	
	if stats:
		stats.damaged.connect(_on_damaged)
		stats.died.connect(_on_died)
	
	if inventory:
		inventory.item_used.connect(_on_item_used)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera_pivot.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI/2, PI/2)
	
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed("attack") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if combat:
			combat.try_attack()


func _process(delta: float) -> void:
	if hit_flash_timer > 0:
		hit_flash_timer -= delta
		if hit_flash_timer <= 0 and mesh:
			_reset_material()


func _physics_process(delta: float) -> void:
	if not stats or not stats.is_alive:
		return
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()


func _on_damaged(_amount: float, _type: StringName) -> void:
	_flash_red()


func _on_died() -> void:
	print("Player morreu!")


func _on_item_used(item: ItemData) -> void:
	print("Usando item: %s" % item.item_name)
	
	if stats:
		if item.heal_amount > 0:
			stats.heal(item.heal_amount)
		if item.stamina_restore > 0:
			stats.restore_stamina(item.stamina_restore)
	
	if survival:
		if item.hunger_restore > 0:
			survival.restore_hunger(item.hunger_restore)
		if item.thirst_restore > 0:
			survival.restore_thirst(item.thirst_restore)


func _flash_red() -> void:
	if not mesh:
		return
	
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = Color(1, 0.3, 0.3)
	mesh.set_surface_override_material(0, material)
	hit_flash_timer = 0.15


func _reset_material() -> void:
	if mesh:
		mesh.set_surface_override_material(0, null)
