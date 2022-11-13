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
		_new_tile.pos.x = 14 if is_left else 0
		_old_tile = null
		
	_new_tile.pos.y = a_row
	
	if is_left:
		_old_tile = tile_container.get_child(0)
		tile_container.add_child(_new_tile)
		tile_container.remove_child(_old_tile)
		for t in $HBoxContainer.get_children():
			t.pos.x -= 1
	else:
		_old_tile = tile_container.get_child((tile_container.get_child_count() - 1))
		tile_container.add_child(_new_tile)
		tile_container.move_child(_new_tile, 0)
		tile_container.remove_child(_old_tile)
		for t in $HBoxContainer.get_children():
			t.pos.x += 1
	
	if G.current_player_position.y == a_row:
		if is_left:
			if G.current_player_position.x == 0:
				G.current_player_position.x = 14
				G.current_player_tile = tile_container.get_child(14)
				G.current_player_connector = G.current_player_tile.get_connector_by_enum(G.current_player_connector.connection_point)
				G.emit_signal("player_position_updated")
			else:
				G.current_player_position.x -= 1
				G.current_player_tile = tile_container.get_child(G.current_player_position.x)
				G.current_player_connector = G.current_player_tile.get_connector_by_enum(G.current_player_connector.connection_point)
				G.emit_signal("player_position_updated")
		else:
			if G.current_player_position.x == 14:
				G.current_player_position.x = 0
				G.current_player_tile = tile_container.get_child(0)
				G.current_player_connector = G.current_player_tile.get_connector_by_enum(G.current_player_connector.connection_point)
				G.emit_signal("player_position_updated")
			else:
				G.current_player_position.x += 1
				G.current_player_tile = tile_container.get_child(G.current_player_position.x)
				G.current_player_connector = G.current_player_tile.get_connector_by_enum(G.current_player_connector.connection_point)
				G.emit_signal("player_position_updated")
	_new_tile = null

func has_tile(tile: Control) -> bool:
	return has_node(tile.get_path())


func get_tile_x_position(tile: Control) -> int:
#	if not has_tile(tile):
#		return -1
	
	var counter = -1
	
	for c in get_children():
		counter += 1
		if c == tile:
			return counter
	
	return -1


func get_tile_at_x_position(x: int) -> Control:
	return $HBoxContainer.get_child(x) as Control


func replace_tile_at_x_position(x: int, tile: Control) -> void:
	tile.pos.y = row
	$HBoxContainer.add_child(tile)
	$HBoxContainer.move_child(tile, x)
