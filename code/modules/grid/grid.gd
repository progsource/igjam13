extends VBoxContainer


const RowScene = preload("res://modules/grid/row.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, 6):
		var row = RowScene.instance()
		row.row = i
		add_child(row)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
