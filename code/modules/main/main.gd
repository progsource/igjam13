extends Node2D


func _ready():
	$StartPosition.visible = false
	$PlayerCharacter.visible = false
	
	# warning-ignore:return_value_discarded
	$PauseLayer/Panel/StartButton.connect("button_up", self, "_restart")
	
	# warning-ignore:return_value_discarded
	G.connect("arrow_button_pressed", self, "_on_arrow_button_pressed")


func _restart() -> void:
	$PauseLayer/Panel/StartButton.text = "Restart"
	G.available_moves = G.MAX_AVAILABLE_MOVES
	
	_place_pc_start_position()
	
	$PauseLayer.visible = false
	
	_start_pc_turn()


func _place_pc_start_position() -> void:
	var x = G.rng.randi_range(0, 15)
	var left_most_x := 68
	var multiplier := 36
	var start_pos = Vector2(left_most_x + multiplier * x, 324)
	
	$StartPosition.position = start_pos
	$PlayerCharacter.position = start_pos
	
	$StartPosition.visible = true
	$PlayerCharacter.visible = true


func _start_pc_turn() -> void:
	G.current_game_state = G.GAME_STATE.PC_ROW_TURN
	G.emit_signal("arrow_buttons_enabled", true)


func _on_arrow_button_pressed(_row: int, _is_left: bool) -> void:
	G.emit_signal("arrow_buttons_enabled", false)
	
	
	G.current_game_state = G.GAME_STATE.PC_MOVE_TURN
