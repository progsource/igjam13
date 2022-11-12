extends Node2D


func _ready():
	$StartPosition.visible = false
	$PlayerCharacter.visible = false
	
	# warning-ignore:return_value_discarded
	$PauseLayer/Panel/StartButton.connect("button_up", self, "_restart")
	
	# warning-ignore:return_value_discarded
	G.connect("arrow_button_pressed", self, "_on_arrow_button_pressed")
	G.connect("character_move_tried", self, "_on_character_move_tried")


func _restart() -> void:
	$PauseLayer/Panel/StartButton.text = "Restart"
	G.available_moves = G.MAX_AVAILABLE_MOVES
	G.current_player_tile = null
	G.current_player_connector = null
	G.current_player_position = Vector2(-1, -1)
	G.current_enemy_tile = null
	G.current_enemy_connector = null
	G.current_enemy_position = Vector2(-1, -1)
	
	G.emit_signal("restart")
	
	_place_pc_start_position()
	
	$PauseLayer.visible = false
	
	_start_pc_turn()


func _place_pc_start_position() -> void:
	var x = G.rng.randi_range(0, 14)
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


func _start_pc_turn() -> void:
	G.current_game_state = G.GAME_STATE.PC_ROW_TURN
	G.emit_signal("arrow_buttons_enabled", true)


func _on_arrow_button_pressed(_row: int, is_left: bool) -> void:
	G.emit_signal("arrow_buttons_enabled", false)
	
	if is_left and G.current_player_position.x == 0:
		print("check if correct row, then let him spawn on the other side")
	elif not is_left and G.current_player_position.x == 14:
		 print("check if correct row, then let him spawn on the other side")
	
	G.current_game_state = G.GAME_STATE.PC_MOVE_TURN


func _on_character_move_tried(tile, connector) -> void:
	var tile_position = tile.pos
	var player_position = G.current_player_position
	var is_player_on_start = player_position.y == 6
	
	G.print_test("tile:")
	G.print_test(tile_position)
	G.print_test("player:")
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
				G.current_player_connector = connector
				G.current_player_tile = tile
				G.available_moves -= 1
				$PlayerCharacter.position.x += 8 if connector.connection_point == G.CONNECTION_POINTS.BOTTOM_RIGHT else -8
				$PlayerCharacter.position.y -= 24
				return
			else:
				print("check if points are connected")
				if tile.has_connection(connector.connection_point, G.current_player_tile, G.current_player_connector.connection_point):
					G.print_test("do move up")
					G.current_player_position.y = tile_position.y
					G.current_player_connector = connector
					G.current_player_tile = tile
					G.available_moves -= 1
					$PlayerCharacter.position = connector.get_global_position()
					return
				else:
					G.print_test("points are not connected")
					return
		else:
			G.print_test("move not possible")
	
	if is_player_on_start:
		# player can only move up from start
		return
	
	if tile_position.y == player_position.y:
		if tile_position.x == player_position.y:
			G.print_test("move not possible")
		elif tile_position.x == player_position.x - 1:
			G.print_test("trying to move left")
			if tile.has_connection(connector.connection_point, G.current_player_tile, G.current_player_connector.connection_point):
				G.print_test("do move left")
				G.current_player_position.x = tile_position.x
				G.current_player_connector = connector
				G.current_player_tile = tile
				G.available_moves -= 1
				$PlayerCharacter.position = connector.get_global_position()
				return
			else:
				G.print_test("points are not connected")
				return
		elif tile_position.x == player_position.x + 1:
			G.print_test("trying to move right")
			if tile.has_connection(connector.connection_point, G.current_player_tile, G.current_player_connector.connection_point):
				G.print_test("do move right")
				G.current_player_position.x = tile_position.x
				G.current_player_connector = connector
				G.current_player_tile = tile
				G.available_moves -= 1
				$PlayerCharacter.position = connector.get_global_position()
				return
			else:
				G.print_test("points are not connected")
				return
		else:
			G.print_test("move not possible")
	elif tile_position.y == player_position.y + 1:
		if tile_position.x == player_position.x:
			G.print_test("trying to move down")
			if tile.has_connection(connector.connection_point, G.current_player_tile, G.current_player_connector.connection_point):
				G.print_test("do move down")
				G.current_player_position.y = tile_position.y
				G.current_player_connector = connector
				G.current_player_tile = tile
				G.available_moves -= 1
				$PlayerCharacter.position = connector.get_global_position()
				return
			else:
				G.print_test("points are not connected")
				return
		else:
			G.print_test("move not possible")
	else:
		G.print_test("move not possible")
