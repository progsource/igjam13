extends Node2D


var goal_position := Vector2(-1, -1)


func _ready():
	$StartPosition.visible = false
	$PlayerCharacter.visible = false
	$Goal.visible = false
	
	# warning-ignore:return_value_discarded
	$PauseLayer/Panel/VBoxContainer/StartButton.connect("button_up", self, "_restart")
	# warning-ignore:return_value_discarded
	$Goal/StaticBody2D.connect("input_event", self, "_on_goal_input")
	
	# warning-ignore:return_value_discarded
	G.connect("arrow_button_pressed", self, "_on_arrow_button_pressed")
	# warning-ignore:return_value_discarded
	G.connect("character_move_tried", self, "_on_character_move_tried")
	
	# warning-ignore:return_value_discarded
	G.connect("game_state_updated", self, "_on_game_state_updated")
	
	# warning-ignore:return_value_discarded
	G.connect("end_state", self, "_on_end_state_changed")
	
	G.connect("player_position_updated", self, "_on_player_position_updated")


func _on_player_position_updated() -> void:
	G.print_test("on player pos change")
	G.print_test(G.current_player_connector.parent_tile.pos)
	G.print_test("pc pos")
	G.print_test($PlayerCharacter.position)
	call_deferred("_update_pc_pos_now")


func _update_pc_pos_now():
	$PlayerCharacter.position = G.current_player_connector.get_global_position()
	G.print_test($PlayerCharacter.position)


func _on_end_state_changed(state: int) -> void:
	var end_state = $PauseLayer/Panel/VBoxContainer/EndState
	end_state.text = "YOU WON!" if state == G.GAME_END_STATE.WON else "GAME OVER!"
	end_state.visible = true


func _on_goal_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if G.available_moves < 1:
		return # failed ;p

	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if G.current_player_position.x == goal_position.x and G.current_player_position.y == goal_position.y + 1:
			var other_connector = G.current_player_tile.get_connected_position(G.current_player_connector.connection_point)
			
			if (G.current_player_connector.connection_point == G.CONNECTION_POINTS.TOP_LEFT or
				G.current_player_connector.connection_point == G.CONNECTION_POINTS.TOP_RIGHT or
				other_connector == G.CONNECTION_POINTS.TOP_LEFT or
				other_connector == G.CONNECTION_POINTS.TOP_RIGHT):
			
				G.emit_signal("end_state", G.GAME_END_STATE.WON)
				$PauseLayer.visible = true


func _on_game_state_updated() -> void:
	if G.current_game_state == G.GAME_STATE.AI_ROW_TURN:
		$Grid.move_column(
			G.rng.randi_range(0, G.MAX_TILES_PER_ROW),
			G.rng.randi_range(0,100) > 50)
		G.current_game_state = G.GAME_STATE.PC_ROW_TURN # theoretically this would be the enemies move turn
	elif G.current_game_state == G.GAME_STATE.PAUSE:
		$PauseLayer.visible = true


func _restart() -> void:
	$PauseLayer/Panel/VBoxContainer/StartButton.text = "Restart"
	G.available_moves = G.MAX_AVAILABLE_MOVES
	G.current_player_tile = null
	G.current_player_connector = null
	G.current_player_position = Vector2(-1, -1)
	G.current_enemy_tile = null
	G.current_enemy_connector = null
	G.current_enemy_position = Vector2(-1, -1)
	
	G.emit_signal("restart")
	
	_place_pc_start_position()
	_place_goal_position()
	
	$PauseLayer.visible = false
	
	_start_pc_turn()


func _place_pc_start_position() -> void:
	var x = G.rng.randi_range(0, G.MAX_TILES_PER_ROW)
	var left_most_x := 68
	var multiplier := 36
	var start_pos = Vector2(left_most_x + multiplier * x, 324)
#	var start_pos = Vector2(left_most_x + multiplier * x, 107)

	G.current_player_position.x = x
	G.current_player_position.y = 6
	
	$StartPosition.position = start_pos
	$PlayerCharacter.position = start_pos
	
	$StartPosition.visible = true
	$PlayerCharacter.visible = true


func _place_goal_position() -> void:
	var x = G.rng.randi_range(0, G.MAX_TILES_PER_ROW)
	var left_most_x := 68
	var multiplier := 36
	var start_pos = Vector2(left_most_x + multiplier * x, 71)
	
	goal_position.x = x
	$Goal.position = start_pos
	$Goal.visible = true


func _start_pc_turn() -> void:
	G.current_game_state = G.GAME_STATE.PC_ROW_TURN
	G.emit_signal("arrow_buttons_enabled", true)


func _on_arrow_button_pressed(_row: int, is_left: bool) -> void:
	G.emit_signal("arrow_buttons_enabled", false)
	
	if is_left and G.current_player_position.x == 0:
		print("check if correct row, then let him spawn on the other side")
	elif not is_left and G.current_player_position.x == G.MAX_TILES_PER_ROW:
		 print("check if correct row, then let him spawn on the other side")
	
	G.current_game_state = G.GAME_STATE.PC_MOVE_TURN


func _on_character_move_tried(tile, connector) -> void:
	G.print_test("on try character move")
	var tile_position = tile.pos
	var player_position = G.current_player_position
	var is_player_on_start = player_position.y == 6
	
	G.print_test("tile pos:")
	G.print_test(tile_position)
	G.print_test("player pos:")
	G.print_test(player_position)

	if tile_position.y == player_position.y - 1:
		if tile_position.x == player_position.x:
			G.print_test("trying to move up")
			if is_player_on_start and connector.connection_point != G.CONNECTION_POINTS.BOTTOM_LEFT and connector.connection_point != G.CONNECTION_POINTS.BOTTOM_RIGHT:
				G.print_test("connector not selected from bottom on start")
				return
			elif is_player_on_start:
				G.print_test("do move up from start")
				G.current_player_position.y = tile_position.y
				G.current_player_tile = tile
				G.current_player_connector = connector
				G.available_moves -= 1
				G.emit_signal("player_position_updated")
				return
			else:
				print("check if points are connected")
				if tile.has_connection(connector.connection_point, G.current_player_tile, G.current_player_connector.connection_point):
					G.print_test("do move up")
					G.current_player_position.y = tile_position.y
					G.current_player_tile = tile
					G.current_player_connector = connector
					G.available_moves -= 1
					G.emit_signal("player_position_updated")
					return
				else:
					G.print_test("points are not connected")
					return
		else:
			G.print_test("move not possible - diagonal")
	
	if is_player_on_start:
		# player can only move up from start
		return
	
	if tile_position.y == player_position.y:
		if tile_position.x == player_position.x:
			G.print_test("move not possible - no movement")
		elif tile_position.x == player_position.x - 1:
			G.print_test("trying to move left")
			if tile.has_connection(connector.connection_point, G.current_player_tile, G.current_player_connector.connection_point):
				G.print_test("do move left")
				G.current_player_position.x = tile_position.x
				G.current_player_tile = tile
				G.current_player_connector = connector
				G.available_moves -= 1
				G.emit_signal("player_position_updated")
				return
			else:
				G.print_test("points are not connected")
				return
		elif tile_position.x == player_position.x + 1:
			G.print_test("trying to move right")
			if tile.has_connection(connector.connection_point, G.current_player_tile, G.current_player_connector.connection_point):
				G.print_test("do move right")
				G.current_player_position.x = tile_position.x
				G.current_player_tile = tile
				G.current_player_connector = connector
				G.available_moves -= 1
				G.emit_signal("player_position_updated")
				return
			else:
				G.print_test("points are not connected")
				return
		else:
			G.print_test("move not possible - too far away")
	elif tile_position.y == player_position.y + 1:
		if tile_position.x == player_position.x:
			G.print_test("trying to move down")
			if tile.has_connection(connector.connection_point, G.current_player_tile, G.current_player_connector.connection_point):
				G.print_test("do move down")
				G.current_player_position.y = tile_position.y
				G.current_player_tile = tile
				G.current_player_connector = connector
				G.available_moves -= 1
				G.emit_signal("player_position_updated")
				return
			else:
				G.print_test("points are not connected")
				return
		else:
			G.print_test("move not possible - diagonal")
	else:
		G.print_test("move not possible - too far away")
