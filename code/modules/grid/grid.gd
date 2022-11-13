extends VBoxContainer


const RowScene = preload("res://modules/grid/row.tscn")
const TileScene = preload("res://modules/grid/tile.tscn")


var _old_tile = null
var _new_tile = null


# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	G.connect("restart", self, "restart")
	


func _exit_tree():
	if _old_tile != null:
		_old_tile.queue_free()
	if _new_tile != null:
		_new_tile.queue_free()


func restart() -> void:
	for c in get_children():
		remove_child(c)
		c.queue_free()

	for i in range(0, 6):
		var row = RowScene.instance()
		row.row = i
		add_child(row)


func move_column(pos_x: int, is_up: bool) -> void:
	var tiles := []
	
	for row in get_children():
		tiles.append(row.get_tile_at_x_position(pos_x))
	
	if _old_tile == null and _new_tile == null:
		_new_tile = TileScene.instance()
		_new_tile.possible_connections = 4
	elif _old_tile != null:
		_new_tile = _old_tile
		_old_tile = null
	
	_new_tile.pos.x = pos_x
	_new_tile.pos.y = 5 if is_up else 0
	_old_tile = tiles[0 if is_up else 5]
	
	if is_up:
		for t in range(tiles.size() - 1):
			if t >= tiles.size() - 1:
				break
			tiles[t + 1].get_parent().remove_child(tiles[t + 1])
			get_child(t).replace_tile_at_x_position(pos_x, tiles[t + 1])
			tiles[t] = tiles[t + 1]
		_old_tile.get_parent().remove_child(_old_tile)
		get_child(tiles.size() - 1).replace_tile_at_x_position(pos_x, _new_tile)
		tiles[tiles.size() - 1] = _new_tile
	else:
		for t in [5, 4, 3, 2, 1]:
			tiles[t - 1].get_parent().remove_child(tiles[t - 1])
			get_child(t).replace_tile_at_x_position(pos_x, tiles[t - 1])
			tiles[t] = tiles[t - 1]
		_old_tile.get_parent().remove_child(_old_tile)
		get_child(0).replace_tile_at_x_position(pos_x, _new_tile)
		tiles[0] = _new_tile
	
	if G.current_player_position.x == pos_x and G.current_player_position.y != 6:
		if is_up:
			if G.current_player_position.y == 0:
				G.current_player_position.y = 5
			else:
				G.current_player_position.y -= 1
		else:
			if G.current_player_position.y == 5:
				G.current_player_position.y = 0
			else:
				G.current_player_position.y += 1

		G.current_player_tile = get_tile_at(G.current_player_position.x, G.current_player_position.y)
		G.current_player_connector = G.current_player_tile.get_connector_by_enum(G.current_player_connector.connection_point)
		G.emit_signal("player_position_updated")
	_new_tile = null


func get_tile_at(x: int, y: int) -> Control:
	assert(y > -1)
	assert(y < get_child_count())
	return get_child(y).get_tile_at_x_position(x)
