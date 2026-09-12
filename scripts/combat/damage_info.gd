class_name DamageInfo
extends RefCounted
## Informações de dano para o sistema de combate
##
## Carrega todos os dados necessários para processar um hit

var amount: float = 0.0
var damage_type: StringName = &"slash"
var poise_damage: float = 0.0
var knockback: Vector3 = Vector3.ZERO
var source: Node = null
var can_be_blocked: bool = true
var can_be_parried: bool = true


func _init(
	p_amount: float = 0.0,
	p_type: StringName = &"slash",
	p_poise: float = 0.0,
	p_knockback: Vector3 = Vector3.ZERO,
	p_source: Node = null
) -> void:
	amount = p_amount
	damage_type = p_type
	poise_damage = p_poise
	knockback = p_knockback
	source = p_source
