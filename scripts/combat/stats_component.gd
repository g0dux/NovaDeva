class_name StatsComponent
extends Node
## Componente de estatísticas para player e inimigos
##
## Gerencia HP, stamina e aplicação de dano

signal health_changed(current: float, maximum: float)
signal stamina_changed(current: float, maximum: float)
signal died()
signal damaged(amount: float, damage_type: StringName)

@export var max_health: float = 100.0
@export var max_stamina: float = 100.0
@export var stamina_regen_rate: float = 25.0
@export var stamina_regen_delay: float = 0.8

var current_health: float = 100.0
var current_stamina: float = 100.0
var is_alive: bool = true

var _stamina_regen_timer: float = 0.0


func _ready() -> void:
	current_health = max_health
	current_stamina = max_stamina
	health_changed.emit(current_health, max_health)
	stamina_changed.emit(current_stamina, max_stamina)


func _process(delta: float) -> void:
	if _stamina_regen_timer > 0:
		_stamina_regen_timer -= delta
	
	if _stamina_regen_timer <= 0 and current_stamina < max_stamina:
		var old_stamina: float = current_stamina
		current_stamina = min(current_stamina + stamina_regen_rate * delta, max_stamina)
		if current_stamina != old_stamina:
			stamina_changed.emit(current_stamina, max_stamina)


func apply_damage(info: DamageInfo) -> bool:
	if not is_alive:
		return false
	
	current_health -= info.amount
	damaged.emit(info.amount, info.damage_type)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		current_health = 0
		is_alive = false
		died.emit()
		return true
	
	return false


func consume_stamina(amount: float) -> bool:
	if current_stamina < amount:
		return false
	
	current_stamina -= amount
	_stamina_regen_timer = stamina_regen_delay
	stamina_changed.emit(current_stamina, max_stamina)
	return true


func heal(amount: float) -> void:
	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)


func restore_stamina(amount: float) -> void:
	current_stamina = min(current_stamina + amount, max_stamina)
	stamina_changed.emit(current_stamina, max_stamina)
