extends Node

# warning-ignore:unused_signal
signal restart()
signal available_moves_updated()
# warning-ignore:unused_signal
signal arrow_button_pressed(row, is_left)
# warning-ignore:unused_signal
signal arrow_buttons_enabled(enabled)
# warning-ignore:unused_signal
signal connector_pressed(connector_tile, connector)

# warning-ignore:unused_signal
signal character_move_tried(tile, connector)

signal game_state_updated()

# warning-ignore:unused_signal
signal player_position_updated()


enum GAME_STATE {
	PAUSE,
	PC_ROW_TURN,
	PC_MOVE_TURN,
	AI_ROW_TURN,
	AI_MOVE_TURN,
}

enum CONNECTION_POINTS {
	TOP_LEFT,
	TOP_RIGHT,
	RIGHT_TOP,
	RIGHT_BOTTOM,
	BOTTOM_RIGHT,
	BOTTOM_LEFT,
	LEFT_BOTTOM,
	LEFT_TOP,
}


const MAX_AVAILABLE_MOVES := 30


onready var rng := RandomNumberGenerator.new()


var available_moves := 0 setget set_available_moves


var current_game_state = GAME_STATE.PAUSE setget set_current_game_state
var current_player_tile = null
var current_player_connector = null
var current_player_position := Vector2(-1, -1)
var current_enemy_tile = null
var current_enemy_connector = null
var current_enemy_position := Vector2(-1, -1)


func _ready():
	rng.randomize()


func set_available_moves(value: int) -> void:
	available_moves = value
	emit_signal("available_moves_updated")


func set_current_game_state(value: int) -> void:
	current_game_state = value
	emit_signal("game_state_updated")


func print_test(s) -> void:
	if OS.is_debug_build():
		print(s)
