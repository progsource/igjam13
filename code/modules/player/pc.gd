extends Node2D


func _ready():
	# warning-ignore:return_value_discarded
	G.connect("connector_pressed", self, "_on_connector_pressed")


func _on_connector_pressed(tile, connector) -> void:
	if G.current_game_state != G.GAME_STATE.PC_MOVE_TURN:
		return
	if G.available_moves <= 0:
		return

	G.emit_signal("character_move_tried", tile, connector)
	if G.available_moves <= 0:
		G.emit_signal("end_state", G.GAME_END_STATE.GAME_OVER)
		G.current_game_state = G.GAME_STATE.PAUSE


