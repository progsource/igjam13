extends HBoxContainer


const TileScene = preload("res://modules/grid/tile.tscn")


export var row := -1 setget set_row


onready var tile_container = $HBoxContainer


var _old_tile = null
var _new_tile = null


func _ready():
	# warning-ignore:return_value_discarded
	G.connect("arrow_button_pressed", self, "_on_arrow_button_pressed")


func _exit_tree():
	if _old_tile != null:
		_old_tile.queue_free()
	if _new_tile != null:
		_new_tile.queue_free()


func set_row(value: int) -> void:
	row = value
	$ArrowLeft.row = row
	$ArrowRight.row = row
	
	for t in $HBoxContainer.get_children():
		t.pos.y = value


func _on_arrow_button_pressed(a_row: int, is_left: bool) -> void:
	if row != a_row:
		return
	
	print("row: %d - is_left: %s" % [a_row, is_left])
	
	if _old_tile == null and _new_tile == null:
		_new_tile = TileScene.instance()
		_new_tile.possible_connections = 4
	elif _old_tile != null:
		_new_tile = _old_tile
		_old_tile = null
	
	_new_tile.pos.x = 14 if is_left else 0
	_new_tile.pos.y = a_row
	G.print_test("starting new tile pos:")
	G.print_test(_new_tile.pos)
	
	if is_left:
		_old_tile = tile_container.get_child(0)
		tile_container.add_child(_new_tile)
		tile_container.remove_child(_old_tile)
		
		for t in range($HBoxContainer.get_children().size()):
			if t == $HBoxContainer.get_children().size() - 1:
				continue
			$HBoxContainer.get_children()[t].pos.x -= 1
	else:
		_old_tile = tile_container.get_child((tile_container.get_child_count() - 1))
		tile_container.add_child(_new_tile)
		tile_container.move_child(_new_tile, 0)
		tile_container.remove_child(_old_tile)
		var first_skipped = false
		for t in $HBoxContainer.get_children():
			if not first_skipped:
				first_skipped = true
				continue
			t.pos.x += 1
	G.print_test("current player pos:")
	G.print_test(G.current_player_position)
	G.print_test("a row: %d" % a_row)
	if G.current_player_position.y == a_row:
		if is_left:
			if G.current_player_position.x == 0:
				G.current_player_position.x = 14
			else:
				G.current_player_position.x -= 1
		else:
			if G.current_player_position.x == 14:
				G.current_player_position.x = 0
			else:
				G.current_player_position.x += 1
		G.print_test("new player pos:")
		G.print_test(G.current_player_position)
		G.current_player_tile = tile_container.get_child(G.current_player_position.x)
		G.current_player_connector = G.current_player_tile.get_connector_by_enum(G.current_player_connector.connection_point)
		G.emit_signal("player_position_updated")
	G.print_test("new tile pos:")
	G.print_test(_new_tile.pos)
	_new_tile = null


func get_tile_at_x_position(x: int) -> Control:
	return $HBoxContainer.get_child(x) as Control


func replace_tile_at_x_position(x: int, tile: Control) -> void:
	tile.pos.x = x
	tile.pos.y = row
	$HBoxContainer.add_child(tile)
	$HBoxContainer.move_child(tile, x)
