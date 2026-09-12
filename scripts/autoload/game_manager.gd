extends Node
## Game Manager - Singleton para gerenciar estado global do jogo
##
## Este autoload gerencia sistemas centrais como:
## - Estado do jogo (menu, gameplay, pause)
## - Transições entre cenas
## - Configurações globais
## - Sistema de eventos

signal game_state_changed(new_state: GameState)

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	LOADING
}

var current_state: GameState = GameState.MENU:
	set(value):
		if current_state != value:
			current_state = value
			game_state_changed.emit(current_state)

var player: Node3D = null


func _ready() -> void:
	print("GameManager iniciado")
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause"):
		toggle_pause()


func toggle_pause() -> void:
	if current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
		get_tree().paused = true
	elif current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
		get_tree().paused = false


func start_game() -> void:
	current_state = GameState.PLAYING
	get_tree().paused = false


func load_scene(scene_path: String) -> void:
	current_state = GameState.LOADING
	get_tree().change_scene_to_file(scene_path)
