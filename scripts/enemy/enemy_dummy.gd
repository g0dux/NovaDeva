extends CharacterBody3D
## Enemy Dummy - Alvo de treinamento
##
## Inimigo simples que pode tomar dano e morrer

@onready var stats: StatsComponent = $StatsComponent
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var label: Label3D = $Label3D

var hit_flash_timer: float = 0.0


func _ready() -> void:
	if stats:
		stats.health_changed.connect(_on_health_changed)
		stats.damaged.connect(_on_damaged)
		stats.died.connect(_on_died)
		_update_label()


func _process(delta: float) -> void:
	if hit_flash_timer > 0:
		hit_flash_timer -= delta
		if hit_flash_timer <= 0:
			_reset_material()


func _on_health_changed(_current: float, _maximum: float) -> void:
	_update_label()


func _on_damaged(amount: float, _type: StringName) -> void:
	print("Dummy tomou %d de dano!" % amount)
	_flash_damage()


func _on_died() -> void:
	print("Dummy foi derrotado!")
	await get_tree().create_timer(0.5).timeout
	queue_free()


func _update_label() -> void:
	if stats and label:
		label.text = "HP: %.0f/%.0f" % [stats.current_health, stats.max_health]


func _flash_damage() -> void:
	if not mesh:
		return
	
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(1, 0.5, 0.5)
	mesh.set_surface_override_material(0, material)
	hit_flash_timer = 0.2


func _reset_material() -> void:
	if mesh:
		mesh.set_surface_override_material(0, null)
