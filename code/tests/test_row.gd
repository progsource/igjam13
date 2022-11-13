extends GutTest


const RowScene = preload("res://modules/grid/row.tscn")
const TileScene = preload("res://modules/grid/tile.tscn")


func test_get_tile_at_x_position():
	var instance = autofree(RowScene.instance())
	instance.row = 2
	
	var tile = instance.get_tile_at_x_position(3)
	
	assert_eq(tile.pos.x, 3.0)
	assert_eq(tile.pos.y, 2.0)


func test_replace_tile():
	var tile = autofree(TileScene.instance())
	tile.pos.x = 3
	tile.pos.y = 5
	
	var row = add_child_autoqfree(RowScene.instance())
	row.row = 4
	
	var old = row.get_tile_at_x_position(14)
	old.get_parent().remove_child(old)
	old.queue_free()
	
	row.replace_tile_at_x_position(14, tile)
	
	assert_eq(tile.pos.x, 14.0)
	assert_eq(tile.pos.y, 4.0)
	
	var double_tile = row.get_tile_at_x_position(14)
	
	assert_eq(double_tile, tile)
