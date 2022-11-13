extends GutTest


const RowScene = preload("res://modules/grid/row.tscn")
const TileScene = preload("res://modules/grid/tile.tscn")


var row_test = null


func before_each():
	row_test = add_child_autoqfree(RowScene.instance())


func test_get_tile_at_x_position():
	row_test.row = 2
	
	var tile = row_test.get_tile_at_x_position(3)
	
	assert_eq(tile.pos.x, 3.0)
	assert_eq(tile.pos.y, 2.0)


func test_replace_tile():
	var tile = autofree(TileScene.instance())
	tile.pos.x = 3
	tile.pos.y = 5

	row_test.row = 4

	var old = row_test.get_tile_at_x_position(14)
	old.get_parent().remove_child(old)
	old.queue_free()
	
	row_test.replace_tile_at_x_position(14, tile)

	assert_eq(tile.pos.x, 14.0)
	assert_eq(tile.pos.y, 4.0)

	var double_tile = row_test.get_tile_at_x_position(14)

	assert_eq(double_tile, tile)


var update_player_position_parameters := [
	# row, shadow_row, player_start_tile.x, player_start_tile.y,
	# updated_row, is_left, expected player x, emitted signal
	[4, 5, 3, 4, 4, true, 2, true],
	[3, 2, 7, 2, 3, false, 7, false],
	[4, 5, 3, 4, 4, false, 4, true],
	[4, 5, 0, 4, 4, true, 14, true],
	[4, 5, 14, 4, 4, false, 0, true],
]


func test_update_player_position(params=use_parameters(update_player_position_parameters)):
	watch_signals(G)
	
	row_test.row = params[0]
	
	var shadow_row = add_child_autoqfree(RowScene.instance())
	shadow_row.row = params[1]
	
	var player_start_tile = row_test.get_tile_at_x_position(params[2])
	
	G.current_player_tile = player_start_tile
	G.current_player_position.x = float(params[2])
	G.current_player_position.y = float(params[3])
	G.current_player_connector = player_start_tile.get_connector_by_enum(0)
	G.current_player_connector.connection_point = 0
	
	row_test._update_player_position(params[4], params[5])
	
	assert_eq(G.current_player_position.x, float(params[6]))
	
	if params[7]:
		assert_signal_emitted(G, 'player_position_updated')
	else:
		assert_signal_not_emitted(G, 'player_position_updated')
