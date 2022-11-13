extends ColorRect


export(G.CONNECTION_POINTS) var connection_point := -1


var parent_tile = null


func _ready():
	# warning-ignore:return_value_discarded
	connect("mouse_entered", self, "_on_mouse_entered")
	# warning-ignore:return_value_discarded
	connect("mouse_exited", self, "_on_mouse_exited")


func _input(event) -> void:
	if event is InputEventMouseButton:
		if not get_global_rect().has_point(event.position):
			return
			
		if event.button_index == BUTTON_LEFT and event.pressed:
			G.emit_signal("connector_pressed", parent_tile, self)
		

func _on_mouse_entered() -> void:
	if G.current_game_state == G.GAME_STATE.PC_MOVE_TURN:
		color.a = 255


func _on_mouse_exited() -> void:
	color.a = 0
