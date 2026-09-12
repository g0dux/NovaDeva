extends Node
## Game Manager - Singleton para gerenciar estado global do jogo
##
## Este autoload gerencia sistemas centrais como:
## - Estado do jogo (menu, gameplay)
## - Transições entre cenas
## - Configurações globais
## - Sistema de eventos

signal game_state_changed(new_state: GameState)

enum GameState {
	MENU,
	PLAYING,
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


func start_game() -> void:
	current_state = GameState.PLAYING


func load_scene(scene_path: String) -> void:
	current_state = GameState.LOADING
	get_tree().change_scene_to_file(scene_path)
