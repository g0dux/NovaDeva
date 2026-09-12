class_name ItemData
extends Resource
## Dados de item para inventário

@export var item_name: String = "Item"
@export var description: String = ""
@export var icon_path: String = ""
@export var max_stack: int = 1
@export var is_consumable: bool = false
@export var is_equippable: bool = false

## Efeitos de consumo
@export var heal_amount: float = 0.0
@export var stamina_restore: float = 0.0
@export var hunger_restore: float = 0.0
@export var thirst_restore: float = 0.0
