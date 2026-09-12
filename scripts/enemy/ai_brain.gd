class_name AIBrain
extends Node
## IA básica de inimigo com FSM
##
## Estados: IDLE, ALERT, COMBAT, ATTACK, DEAD

signal state_changed(new_state: State)

enum State {
	IDLE,
	ALERT,
	COMBAT,
	ATTACK,
	DEAD
}

@export var detection_range: float = 10.0
@export var attack_range: float = 2.5
@export var attack_cooldown: float = 2.0
@export var move_speed: float = 3.0

var current_state: State = State.IDLE
var target: Node3D = null
var attack_timer: float = 0.0

@onready var enemy: CharacterBody3D = get_parent()
@onready var stats: StatsComponent = enemy.get_node_or_null("StatsComponent")
@onready var combat: Node = enemy.get_node_or_null("CombatComponent")


func _ready() -> void:
	if stats:
		stats.died.connect(_on_died)


func _process(delta: float) -> void:
	if current_state == State.DEAD:
		return
	
	if attack_timer > 0:
		attack_timer -= delta
	
	match current_state:
		State.IDLE:
			_process_idle()
		State.ALERT:
			_process_alert(delta)
		State.COMBAT:
			_process_combat(delta)
		State.ATTACK:
			_process_attack()


func _process_idle() -> void:
	_check_for_player()


func _process_alert(delta: float) -> void:
	if not target or not is_instance_valid(target):
		_change_state(State.IDLE)
		return
	
	var distance: float = enemy.global_position.distance_to(target.global_position)
	
	if distance > detection_range * 1.5:
		_change_state(State.IDLE)
		target = null
		return
	
	if distance <= attack_range:
		_change_state(State.COMBAT)
		return
	
	_move_towards_target(delta)


func _process_combat(delta: float) -> void:
	if not target or not is_instance_valid(target):
		_change_state(State.IDLE)
		return
	
	var distance: float = enemy.global_position.distance_to(target.global_position)
	
	if distance > attack_range * 2.0:
		_change_state(State.ALERT)
		return
	
	if distance <= attack_range and attack_timer <= 0 and combat:
		_change_state(State.ATTACK)
		return
	
	if distance > attack_range:
		_move_towards_target(delta)


func _process_attack() -> void:
	if combat and combat.has_method("try_attack"):
		if combat.try_attack():
			attack_timer = attack_cooldown
	
	_change_state(State.COMBAT)


func _check_for_player() -> void:
	if not GameManager.player:
		return
	
	var distance: float = enemy.global_position.distance_to(GameManager.player.global_position)
	
	if distance <= detection_range:
		target = GameManager.player
		_change_state(State.ALERT)


func _move_towards_target(delta: float) -> void:
	if not target or not enemy:
		return
	
	var direction: Vector3 = (target.global_position - enemy.global_position).normalized()
	direction.y = 0
	
	if direction.length() > 0:
		enemy.velocity.x = direction.x * move_speed
		enemy.velocity.z = direction.z * move_speed
		
		var look_direction: Vector3 = Vector3(direction.x, 0, direction.z)
		if look_direction.length() > 0:
			var target_transform: Transform3D = Transform3D().looking_at(look_direction, Vector3.UP)
			enemy.transform.basis = enemy.transform.basis.slerp(target_transform.basis, delta * 5.0)


func _change_state(new_state: State) -> void:
	if current_state == new_state:
		return
	
	current_state = new_state
	state_changed.emit(new_state)


func _on_died() -> void:
	_change_state(State.DEAD)
	enemy.velocity = Vector3.ZERO
