class_name InventoryComponent
extends Node
## Componente de inventário do player

signal inventory_changed()
signal item_used(item: ItemData)

@export var slot_count: int = 20

var slots: Array[InventorySlot] = []


func _ready() -> void:
	for i in range(slot_count):
		slots.append(InventorySlot.new())


func add_item(item: ItemData, amount: int = 1) -> bool:
	var remaining: int = amount
	
	for slot in slots:
		if slot.can_add(item, remaining):
			remaining = slot.add(item, remaining)
			if remaining <= 0:
				inventory_changed.emit()
				return true
	
	if remaining < amount:
		inventory_changed.emit()
	
	return remaining <= 0


func remove_item(item: ItemData, amount: int = 1) -> bool:
	var remaining: int = amount
	
	for slot in slots:
		if slot.item_data == item:
			var removed: int = slot.remove(remaining)
			remaining -= removed
			if remaining <= 0:
				inventory_changed.emit()
				return true
	
	return false


func get_item_count(item: ItemData) -> int:
	var count: int = 0
	for slot in slots:
		if slot.item_data == item:
			count += slot.quantity
	return count


func use_item(slot_index: int) -> bool:
	if slot_index < 0 or slot_index >= slots.size():
		return false
	
	var slot: InventorySlot = slots[slot_index]
	if slot.is_empty() or not slot.item_data.is_consumable:
		return false
	
	item_used.emit(slot.item_data)
	slot.remove(1)
	inventory_changed.emit()
	return true


func get_slot(index: int) -> InventorySlot:
	if index >= 0 and index < slots.size():
		return slots[index]
	return null
