extends CanvasLayer
## HUD Principal do jogo
##
## Interface básica para exibir:
## - Título/logo do jogo
## - Informações de controle
## - Estado do jogo

@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var info_label: Label = $MarginContainer/VBoxContainer/InfoLabel
@onready var state_label: Label = $TopRight/StateLabel


func _ready() -> void:
	GameManager.game_state_changed.connect(_on_game_state_changed)
	_update_state_display(GameManager.current_state)


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
