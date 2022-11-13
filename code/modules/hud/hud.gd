extends CanvasLayer


func _ready():
	# warning-ignore:return_value_discarded
	G.connect("available_moves_updated", self, "_on_available_moves_updated")
	
	G.connect("game_state_updated", self, "_on_game_state_changed")
# warning-ignore:return_value_discarded
	$Top/Button.connect("button_up", self, "_on_next_turn_pressed")


func _on_available_moves_updated() -> void:
	$Top/Moves.text = str(G.available_moves)


func _on_next_turn_pressed() -> void:
	if G.current_game_state == G.GAME_STATE.PC_MOVE_TURN:
		G.current_game_state = G.GAME_STATE.AI_ROW_TURN


func _on_game_state_changed() -> void:
	match G.current_game_state:
		G.GAME_STATE.PAUSE:
			$Top/GameState.text = "PAUSE"
		G.GAME_STATE.PC_ROW_TURN:
			$Top/GameState.text = "Move Row"
		G.GAME_STATE.PC_MOVE_TURN:
			$Top/GameState.text = "Move PC"
		G.GAME_STATE.AI_ROW_TURN:
			$Top/GameState.text = "AI Row"
		G.GAME_STATE.AI_MOVE_TURN:
			$Top/GameState.text = "AI Move"
