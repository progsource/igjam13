extends Node2D


func _ready():
	# warning-ignore:return_value_discarded
	G.connect("connector_pressed", self, "_on_connector_pressed")
	# warning-ignore:return_value_discarded
	G.connect("player_position_updated", self, "_on_player_position_updated")


func _on_connector_pressed(tile, connector) -> void:
	if G.current_game_state != G.GAME_STATE.PC_MOVE_TURN:
		return
	if G.available_moves <= 0:
		return
	
	G.emit_signal("character_move_tried", tile, connector)
	if G.available_moves <= 0:
		G.current_game_state = G.GAME_STATE.PAUSE


func _on_player_position_updated() -> void:
	position = G.current_player_connector.get_global_position()
