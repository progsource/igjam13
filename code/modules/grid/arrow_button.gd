tool
extends Button


export var is_left := false


func _ready():
	if is_left:
		$Sprite.flip_h = true
	
	# warning-ignore:return_value_discarded
	connect("button_up", self, "_on_arrow_clicked")


func _on_arrow_clicked():
	if is_left:
		print("left")
	else:
		print("right")
