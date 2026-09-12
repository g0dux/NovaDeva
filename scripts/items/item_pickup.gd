extends Area3D
## Item Pickup - Coletável no mundo

@export var item_data: ItemData
@export var quantity: int = 1

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var label: Label3D = $Label3D

var can_pickup: bool = false
var player_in_range: Node3D = null


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if item_data and label:
		label.text = item_data.item_name


func _process(_delta: float) -> void:
	if can_pickup and Input.is_action_just_pressed("interact"):
		_pickup()


func _on_body_entered(body: Node3D) -> void:
	if body == GameManager.player:
		can_pickup = true
		player_in_range = body
		if label:
			label.modulate = Color(0.5, 1, 0.5)


func _on_body_exited(body: Node3D) -> void:
	if body == player_in_range:
		can_pickup = false
		player_in_range = null
		if label:
			label.modulate = Color.WHITE


func _pickup() -> void:
	if not player_in_range or not item_data:
		return
	
	var inventory := player_in_range.get_node_or_null("InventoryComponent") as InventoryComponent
	if inventory and inventory.add_item(item_data, quantity):
		print("Coletou: %s x%d" % [item_data.item_name, quantity])
		queue_free()
	else:
		print("Inventário cheio!")
