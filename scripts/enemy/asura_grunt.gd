extends CharacterBody3D
## Asura Grunt - Inimigo básico agressivo
##
## Inimigo com IA que detecta, persegue e ataca o player

@onready var stats: StatsComponent = $StatsComponent
@onready var ai_brain: AIBrain = $AIBrain
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var label: Label3D = $Label3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var hit_flash_timer: float = 0.0


func _ready() -> void:
	if stats:
		stats.health_changed.connect(_on_health_changed)
		stats.damaged.connect(_on_damaged)
		stats.died.connect(_on_died)
		_update_label()
	
	if ai_brain:
		ai_brain.state_changed.connect(_on_ai_state_changed)


func _physics_process(delta: float) -> void:
	if not stats or not stats.is_alive:
		return
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()


func _process(delta: float) -> void:
	if hit_flash_timer > 0:
		hit_flash_timer -= delta
		if hit_flash_timer <= 0:
			_reset_material()


func _on_health_changed(_current: float, _maximum: float) -> void:
	_update_label()


func _on_damaged(amount: float, _type: StringName) -> void:
	print("Asura Grunt tomou %.0f de dano!" % amount)
	_flash_damage()


func _on_died() -> void:
	print("Asura Grunt foi derrotado!")
	if ai_brain:
		ai_brain.set_process(false)
	
	await get_tree().create_timer(2.0).timeout
	queue_free()


func _on_ai_state_changed(new_state: AIBrain.State) -> void:
	match new_state:
		AIBrain.State.ALERT:
			_set_material_color(Color(1, 1, 0.5))
		AIBrain.State.COMBAT, AIBrain.State.ATTACK:
			_set_material_color(Color(1, 0.5, 0.5))
		AIBrain.State.IDLE:
			_reset_material()


func _update_label() -> void:
	if stats and label:
		label.text = "Asura Grunt\nHP: %.0f/%.0f" % [stats.current_health, stats.max_health]


func _flash_damage() -> void:
	if not mesh:
		return
	
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(1, 0.3, 0.3)
	mesh.set_surface_override_material(0, material)
	hit_flash_timer = 0.15


func _set_material_color(color: Color) -> void:
	if not mesh:
		return
	
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	mesh.set_surface_override_material(0, material)


func _reset_material() -> void:
	if mesh:
		mesh.set_surface_override_material(0, null)
