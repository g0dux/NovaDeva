extends CanvasLayer
## HUD de Combate
##
## Exibe HP, stamina e informações de combate do player

@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@ontml:parameter>
@onready var hp_bar: ProgressBar = $MarginContainer/VBoxContainer/StatsContainer/HPBar
@onready var stamina_bar: ProgressBar = $MarginContainer/VBoxContainer/StatsContainer/StaminaBar
@onready var hp_label: Label = $MarginContainer/VBoxContainer/StatsContainer/HPBar/Label
@onready var stamina_label: Label = $MarginContainer/VBoxContainer/StatsContainer/StaminaBar/Label
@onready var state_label: Label = $TopRight/StateLabel


func _ready() -> void:
	GameManager.game_state_changed.connect(_on_game_state_changed)
	_update_state_display(GameManager.current_state)
	
	await get_tree().process_frame
	_connect_to_player()


func _connect_to_player() -> void:
	if not GameManager.player:
		return
	
	var stats := GameManager.player.get_node_or_null("StatsComponent") as StatsComponent
	if stats:
		stats.health_changed.connect(_on_health_changed)
		stats.stamina_changed.connect(_on_stamina_changed)
		_on_health_changed(stats.current_health, stats.max_health)
		_on_stamina_changed(stats.current_stamina, stats.max_stamina)


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
