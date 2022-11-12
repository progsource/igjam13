extends Node2D


func _ready():
	# warning-ignore:return_value_discarded
	G.connect("connector_pressed", self, "_on_connector_pressed")


func _on_connector_pressed(tile, connector) -> void:
	if G.current_game_state != G.GAME_STATE.PC_MOVE_TURN:
		return
	print(tile)
	print(connector)
	
	G.emit_signal("character_move_tried", tile, connector)
