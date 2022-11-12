extends CanvasLayer


func _ready():
	# warning-ignore:return_value_discarded
	G.connect("available_moves_updated", self, "_on_available_moves_updated")


func _on_available_moves_updated() -> void:
	$Top/Moves.text = str(G.available_moves)


func _on_next_turn_pressed() -> void:
	if G.current_game_state == G.GAME_STATE.PC_MOVE_TURN:
		G.current_game_state = G.GAME_STATE.AI_ROW_TURN
