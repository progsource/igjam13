extends VBoxContainer


const RowScene = preload("res://modules/grid/row.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	G.connect("restart", self, "restart")


func restart() -> void:
	for c in get_children():
		remove_child(c)
		c.queue_free()

	for i in range(0, 6):
		var row = RowScene.instance()
		row.row = i
		add_child(row)


#func is_possible_move(tile, connector, is_player) -> bool:
##	if is_player:
##
#	return false


#func get_tile_at(x: int, y: int) -> Control:
#	var counter = -1
#	for c in get_children():
#		counter += 1
#		if counter == y:
			
	
