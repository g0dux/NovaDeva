class_name SurvivalComponent
extends Node
## Componente de sobrevivência (fome/sede)
##
## Gerencia necessidades básicas seguindo docs/03-sistemas/02-sobrevivencia.md

signal hunger_changed(current: float, maximum: float)
signal thirst_changed(current: float, maximum: float)
signal survival_effect(effect_type: String)

@export var max_hunger: float = 100.0
@export var max_thirst: float = 100.0
@export var hunger_decay_rate: float = 1.0
@export var thirst_decay_rate: float = 1.5

var current_hunger: float = 100.0
var current_thirst: float = 100.0

var tick_timer: float = 0.0
var tick_interval: float = 1.0

@onready var stats: StatsComponent = get_parent().get_node_or_null("StatsComponent")


func _ready() -> void:
	current_hunger = max_hunger
	current_thirst = max_thirst
	hunger_changed.emit(current_hunger, max_hunger)
	thirst_changed.emit(current_thirst, max_thirst)


func _process(delta: float) -> void:
	tick_timer += delta
	
	if tick_timer >= tick_interval:
		tick_timer = 0.0
		_tick_survival()


func _tick_survival() -> void:
	_update_hunger(current_hunger - hunger_decay_rate)
	_update_thirst(current_thirst - thirst_decay_rate)
	_apply_survival_effects()


func _update_hunger(new_value: float) -> void:
	var old_hunger: float = current_hunger
	current_hunger = clamp(new_value, 0.0, max_hunger)
	
	if current_hunger != old_hunger:
		hunger_changed.emit(current_hunger, max_hunger)


func _update_thirst(new_value: float) -> void:
	var old_thirst: float = current_thirst
	current_thirst = clamp(new_value, 0.0, max_thirst)
	
	if current_thirst != old_thirst:
		thirst_changed.emit(current_thirst, max_thirst)


func _apply_survival_effects() -> void:
	if not stats:
		return
	
	if current_hunger < 25:
		var penalty: float = 0.85 if current_hunger >= 10 else 0.70
		survival_effect.emit("low_hunger")
	
	if current_thirst < 25:
		var penalty: float = 0.80 if current_thirst >= 10 else 0.50
		survival_effect.emit("low_thirst")
	
	if current_thirst < 10:
		var damage: DamageInfo = DamageInfo.new(1.0, &"decay", 0.0, Vector3.ZERO, null)
		stats.apply_damage(damage)


func restore_hunger(amount: float) -> void:
	_update_hunger(current_hunger + amount)


func restore_thirst(amount: float) -> void:
	_update_thirst(current_thirst + amount)


func get_hunger_percentage() -> float:
	return (current_hunger / max_hunger) * 100.0


func get_thirst_percentage() -> float:
	return (current_thirst / max_thirst) * 100.0
