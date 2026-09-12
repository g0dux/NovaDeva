class_name InventorySlot
extends RefCounted
## Slot de inventário com item e quantidade

var item_data: ItemData = null
var quantity: int = 0


func _init(p_item: ItemData = null, p_quantity: int = 0) -> void:
	item_data = p_item
	quantity = p_quantity


func is_empty() -> bool:
	return item_data == null or quantity <= 0


func can_add(item: ItemData, amount: int = 1) -> bool:
	if is_empty():
		return true
	
	if item_data == item and quantity + amount <= item_data.max_stack:
		return true
	
	return false


func add(item: ItemData, amount: int = 1) -> int:
	if is_empty():
		item_data = item
		quantity = amount
		return 0
	
	if item_data == item:
		var space_left := item_data.max_stack - quantity
		var added := min(amount, space_left)
		quantity += added
		return amount - added
	
	return amount


func remove(amount: int = 1) -> int:
	var removed := min(amount, quantity)
	quantity -= removed
	
	if quantity <= 0:
		item_data = null
		quantity = 0
	
	return removed


func clear() -> void:
	item_data = null
	quantity = 0
