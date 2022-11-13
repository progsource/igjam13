extends Node2D


func _ready():
	# warning-ignore:return_value_discarded
	G.connect("connector_pressed", self, "_on_connector_pressed")
	
# warning-ignore:return_value_discarded
	G.connect("player_position_updated", self, "_on_player_position_updated")


func _on_connector_pressed(tile, connector) -> void:
	if G.current_game_state != G.GAME_STATE.PC_MOVE_TURN:
		return
	print(tile)
	print(connector)
	
	G.emit_signal("character_move_tried", tile, connector)

func _on_player_position_updated() -> void:
	position = G.current_player_connector.get_global_position()
