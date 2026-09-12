class_name CombatComponent
extends Node
## Componente de combate para o player
##
## Gerencia ataques corpo a corpo, hitboxes e estado de combate

signal attack_started()
signal attack_hit(target: Node)

enum State {
	IDLE,
	ATTACK_WINDUP,
	ATTACK_ACTIVE,
	ATTACK_RECOVERY
}

@export var attack_damage: float = 25.0
@export var attack_stamina_cost: float = 15.0
@export var attack_duration: float = 0.6
@export var attack_range: float = 2.0

@onready var stats: StatsComponent = get_parent().get_node_or_null("StatsComponent")

var current_state: State = State.IDLE
var attack_timer: float = 0.0
var hit_targets: Array[Node] = []


func _ready() -> void:
	if not stats:
		push_error("CombatComponent requires a StatsComponent sibling!")


func _process(delta: float) -> void:
	match current_state:
		State.ATTACK_WINDUP:
			attack_timer -= delta
			if attack_timer <= attack_duration * 0.3:
				_enter_attack_active()
		
		State.ATTACK_ACTIVE:
			attack_timer -= delta
			if attack_timer <= 0:
				_enter_recovery()
		
		State.ATTACK_RECOVERY:
			attack_timer -= delta
			if attack_timer <= 0:
				_enter_idle()


func try_attack() -> bool:
	if current_state != State.IDLE:
		return false
	
	if stats and not stats.consume_stamina(attack_stamina_cost):
		return false
	
	_start_attack()
	return true


func _start_attack() -> void:
	current_state = State.ATTACK_WINDUP
	attack_timer = attack_duration
	hit_targets.clear()
	attack_started.emit()


func _enter_attack_active() -> void:
	current_state = State.ATTACK_ACTIVE
	_perform_hitbox_check()


func _perform_hitbox_check() -> void:
	var parent := get_parent() as Node3D
	if not parent:
		return
	
	var space_state := parent.get_world_3d().direct_space_state
	var query := PhysicsShapeQueryParameters3D.new()
	
	var shape := SphereShape3D.new()
	shape.radius = attack_range
	query.shape = shape
	
	var attack_origin := parent.global_position + parent.global_transform.basis.z * -attack_range * 0.5
	attack_origin.y += 1.0
	
	query.transform = Transform3D(Basis.IDENTITY, attack_origin)
	query.collision_mask = 0b0000_0000_1000_0000
	
	var results := space_state.intersect_shape(query, 10)
	
	for result in results:
		var collider := result.collider as Node
		if collider and collider != parent and collider not in hit_targets:
			_hit_target(collider)
			hit_targets.append(collider)


func _hit_target(target: Node) -> void:
	var target_parent := target.get_parent()
	if not target_parent:
		return
	
	var stats_comp := target_parent.get_node_or_null("StatsComponent") as StatsComponent
	if stats_comp:
		var damage_info := DamageInfo.new(
			attack_damage,
			&"slash",
			10.0,
			Vector3.ZERO,
			get_parent()
		)
		stats_comp.apply_damage(damage_info)
		attack_hit.emit(target_parent)


func _enter_recovery() -> void:
	current_state = State.ATTACK_RECOVERY
	attack_timer = attack_duration * 0.3


func _enter_idle() -> void:
	current_state = State.IDLE
	attack_timer = 0.0


func is_attacking() -> bool:
	return current_state != State.IDLE
