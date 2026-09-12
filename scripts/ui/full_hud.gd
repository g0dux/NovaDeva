extends CanvasLayer
## HUD Completo - Combate, Inventário e Sobrevivência

@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var info_label: Label = $MarginContainer/VBoxContainer/InfoLabel

@onready var hp_bar: ProgressBar = $MarginContainer/VBoxContainer/StatsContainer/HPBar
@onready var stamina_bar: ProgressBar = $MarginContainer/VBoxContainer/StatsContainer/StaminaBar
@onready var hunger_bar: ProgressBar = $MarginContainer/VBoxContainer/StatsContainer/HungerBar
@onready var thirst_bar: ProgressBar = $MarginContainer/VBoxContainer/StatsContainer/ThirstBar

@onready var hp_label: Label = $MarginContainer/VBoxContainer/StatsContainer/HPBar/Label
@onready var stamina_label: Label = $MarginContainer/VBoxContainer/StatsContainer/StaminaBar/Label
@onready var hunger_label: Label = $MarginContainer/VBoxContainer/StatsContainer/HungerBar/Label
@onready var thirst_label: Label = $MarginContainer/VBoxContainer/StatsContainer/ThirstBar/Label

@onready var state_label: Label = $TopRight/StateLabel

@onready var inventory_panel: Panel = $InventoryPanel
@onready var inventory_grid: GridContainer = $InventoryPanel/MarginContainer/VBoxContainer/InventoryGrid
@onready var inventory_title: Label = $InventoryPanel/MarginContainer/VBoxContainer/TitleLabel

var inventory_visible: bool = false


func _ready() -> void:
	GameManager.game_state_changed.connect(_on_game_state_changed)
	_update_state_display(GameManager.current_state)
	
	inventory_panel.visible = false
	
	await get_tree().process_frame
	_connect_to_player()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_inventory"):
		_toggle_inventory()


func _connect_to_player() -> void:
	if not GameManager.player:
		return
	
	var stats := GameManager.player.get_node_or_null("StatsComponent") as StatsComponent
	if stats:
		stats.health_changed.connect(_on_health_changed)
		stats.stamina_changed.connect(_on_stamina_changed)
		_on_health_changed(stats.current_health, stats.max_health)
		_on_stamina_changed(stats.current_stamina, stats.max_stamina)
	
	var survival := GameManager.player.get_node_or_null("SurvivalComponent") as SurvivalComponent
	if survival:
		survival.hunger_changed.connect(_on_hunger_changed)
		survival.thirst_changed.connect(_on_thirst_changed)
		_on_hunger_changed(survival.current_hunger, survival.max_hunger)
		_on_thirst_changed(survival.current_thirst, survival.max_thirst)
	
	var inventory := GameManager.player.get_node_or_null("InventoryComponent") as InventoryComponent
	if inventory:
		inventory.inventory_changed.connect(_on_inventory_changed)
		_update_inventory_ui(inventory)


func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	_update_state_display(new_state)


func _update_state_display(state: GameManager.GameState) -> void:
	match state:
		GameManager.GameState.MENU:
			state_label.text = "[MENU]"
		GameManager.GameState.PLAYING:
			state_label.text = "[JOGANDO]"
		GameManager.GameState.LOADING:
			state_label.text = "[CARREGANDO]"


func _on_health_changed(current: float, maximum: float) -> void:
	if hp_bar:
		hp_bar.max_value = maximum
		hp_bar.value = current
	
	if hp_label:
		hp_label.text = "HP: %.0f/%.0f" % [current, maximum]


func _on_stamina_changed(current: float, maximum: float) -> void:
	if stamina_bar:
		stamina_bar.max_value = maximum
		stamina_bar.value = current
	
	if stamina_label:
		stamina_label.text = "Stamina: %.0f/%.0f" % [current, maximum]


func _on_hunger_changed(current: float, maximum: float) -> void:
	if hunger_bar:
		hunger_bar.max_value = maximum
		hunger_bar.value = current
	
	if hunger_label:
		hunger_label.text = "Fome: %.0f%%" % ((current / maximum) * 100.0)


func _on_thirst_changed(current: float, maximum: float) -> void:
	if thirst_bar:
		thirst_bar.max_value = maximum
		thirst_bar.value = current
	
	if thirst_label:
		thirst_label.text = "Sede: %.0f%%" % ((current / maximum) * 100.0)


func _on_inventory_changed() -> void:
	if not GameManager.player:
		return
	
	var inventory := GameManager.player.get_node_or_null("InventoryComponent") as InventoryComponent
	if inventory:
		_update_inventory_ui(inventory)


func _toggle_inventory() -> void:
	inventory_visible = not inventory_visible
	inventory_panel.visible = inventory_visible
	
	if inventory_visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _update_inventory_ui(inventory: InventoryComponent) -> void:
	for child in inventory_grid.get_children():
		child.queue_free()
	
	for i in range(inventory.slot_count):
		var slot := inventory.get_slot(i)
		var button := Button.new()
		button.custom_minimum_size = Vector2(60, 60)
		
		if slot and not slot.is_empty():
			button.text = "%s\nx%d" % [slot.item_data.item_name, slot.quantity]
			button.pressed.connect(_on_inventory_slot_pressed.bind(i))
		else:
			button.text = "[Vazio]"
			button.disabled = true
		
		inventory_grid.add_child(button)


func _on_inventory_slot_pressed(slot_index: int) -> void:
	if not GameManager.player:
		return
	
	var inventory := GameManager.player.get_node_or_null("InventoryComponent") as InventoryComponent
	if inventory:
		inventory.use_item(slot_index)
