extends Control


const CONNECTION_IMAGE_POSITION_CORNER := 2 * 32
const CONNECTION_IMAGE_POSITION_LINE_CORNER := 3 * 32
const CONNECTION_IMAGE_POSITION_OVER_CROSS := 4 * 32
const CONNECTION_IMAGE_POSITION_STRAIGHT := 5 * 32
const CONNECTION_IMAGE_POSITION_SAME_BORDER := 6 * 32
const CONNECTION_IMAGE_POSITION_FAR_CORNER := 7 * 32


var possible_connections := 4
var connections := []


onready var _connectors := [
	$Background/TopLeftConnector,
	$Background/TopRightConnector,
	$Background/RightTopConnector,
	$Background/RightBottomConnector,
	$Background/BottomRightConnector,
	$Background/BottomLeftConnector,
	$Background/LeftBottomConnector,
	$Background/LeftTopConnector,
]


func _ready():
	for con in _connectors:
		con.color.a = 0
		con.parent_tile = self
	
	_reset_lines()
	_initialize_connections()
	_display_connections()


func _input(event) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		
		if $Background/TopRightConnector.get_global_rect().has_point(event.position):
			print("top right")
			G.emit_signal("connector_pressed", self, G.CONNECTION_POINTS.TOP_RIGHT)
		elif $Background/RightTopConnector.get_global_rect().has_point(event.position):
			print("right top")
			G.emit_signal("connector_pressed", self, G.CONNECTION_POINTS.RIGHT_TOP)
		elif $Background/RightBottomConnector.get_global_rect().has_point(event.position):
			print("right bottom")
			G.emit_signal("connector_pressed", self, G.CONNECTION_POINTS.RIGHT_BOTTOM)
		elif $Background/BottomRightConnector.get_global_rect().has_point(event.position):
			print("bottom right")
			G.emit_signal("connector_pressed", self, G.CONNECTION_POINTS.BOTTOM_RIGHT)
		elif $Background/BottomLeftConnector.get_global_rect().has_point(event.position):
			print("bottom left")
			G.emit_signal("connector_pressed", self, G.CONNECTION_POINTS.BOTTOM_LEFT)
		elif $Background/LeftBottomConnector.get_global_rect().has_point(event.position):
			print("left bottom")
			G.emit_signal("connector_pressed", self, G.CONNECTION_POINTS.LEFT_BOTTOM)
		elif $Background/LeftTopConnector.get_global_rect().has_point(event.position):
			print("left top")
			G.emit_signal("connector_pressed", self, G.CONNECTION_POINTS.LEFT_TOP)


func _initialize_connections() -> void:
	var available_connections := []
	available_connections.resize(G.CONNECTION_POINTS.size())
	for i in range(0, G.CONNECTION_POINTS.size()):
		available_connections[i] = i

	for _i in range(0, possible_connections):
		var connection_point_a = available_connections[G.rng.randi_range(0, available_connections.size() - 1)]
		available_connections.erase(connection_point_a)
		var connection_point_b = available_connections[G.rng.randi_range(0, available_connections.size() - 1)]
		available_connections.erase(connection_point_b)

		connections.append(Vector2(connection_point_a, connection_point_b))


func _reset_lines() -> void:
	for i in range(0, 4):
		var line = get_node("Background/Line%d" % [i + 1]) as Sprite
		line.visible = false
		line.rotation_degrees = 0.0
		line.flip_h = false
		line.flip_v = false


func _display_connections() -> void:
	var counter = 0
	
	for connection in connections:
		counter += 1
		var line = get_node("Background/Line%d" % [counter]) as Sprite
		
		match int(connection.x):
			# from TOP_LEFT
			G.CONNECTION_POINTS.TOP_LEFT:
				match int(connection.y):
					G.CONNECTION_POINTS.TOP_LEFT:
						assert(false)
					G.CONNECTION_POINTS.TOP_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
					G.CONNECTION_POINTS.RIGHT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
						line.rotation_degrees = 90.0
					G.CONNECTION_POINTS.RIGHT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
						line.rotation_degrees = 90.0
					G.CONNECTION_POINTS.BOTTOM_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
						line.rotation_degrees = 90.0
					G.CONNECTION_POINTS.BOTTOM_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
						line.rotation_degrees = 90.0
					G.CONNECTION_POINTS.LEFT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					G.CONNECTION_POINTS.LEFT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
			
			# from TOP_RIGHT
			G.CONNECTION_POINTS.TOP_RIGHT:
				match int(connection.y):
					G.CONNECTION_POINTS.TOP_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
					G.CONNECTION_POINTS.TOP_RIGHT:
						assert(false)
					G.CONNECTION_POINTS.RIGHT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
						line.rotation_degrees = 90.0
					G.CONNECTION_POINTS.RIGHT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
						line.flip_h = true
					G.CONNECTION_POINTS.BOTTOM_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
						line.rotation_degrees = 270.0
					G.CONNECTION_POINTS.BOTTOM_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
						line.rotation_degrees = 90.0
						line.flip_h = true
					G.CONNECTION_POINTS.LEFT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
					G.CONNECTION_POINTS.LEFT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
						line.flip_h = true
						line.rotation_degrees = 270.0
			
			# from RIGHT_TOP
			G.CONNECTION_POINTS.RIGHT_TOP:
				match int(connection.y):
					G.CONNECTION_POINTS.TOP_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
						line.rotation_degrees = 90.0
					G.CONNECTION_POINTS.TOP_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
						line.rotation_degrees = 90.0
					G.CONNECTION_POINTS.RIGHT_TOP:
						assert(false)
					G.CONNECTION_POINTS.RIGHT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
						line.rotation_degrees = 90.0
					G.CONNECTION_POINTS.BOTTOM_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
						line.rotation_degrees = 180.0
					G.CONNECTION_POINTS.BOTTOM_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
						line.rotation_degrees = 180.0
					G.CONNECTION_POINTS.LEFT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
					G.CONNECTION_POINTS.LEFT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
						line.rotation_degrees = 180.0
			
			# from RIGHT_BOTTOM
			G.CONNECTION_POINTS.RIGHT_BOTTOM:
				match int(connection.y):
					G.CONNECTION_POINTS.TOP_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
						line.rotation_degrees = 90.0
					G.CONNECTION_POINTS.TOP_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
						line.flip_h = true
					G.CONNECTION_POINTS.RIGHT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
						line.rotation_degrees = 90.0
					G.CONNECTION_POINTS.RIGHT_BOTTOM:
						assert(false)
					G.CONNECTION_POINTS.BOTTOM_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
						line.rotation_degrees = 180.0
					G.CONNECTION_POINTS.BOTTOM_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
						line.rotation_degrees = 270.0
						line.flip_v = true
					G.CONNECTION_POINTS.LEFT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
					G.CONNECTION_POINTS.LEFT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
						line.flip_v = true
			
			# from BOTTOM_RIGHT
			G.CONNECTION_POINTS.BOTTOM_RIGHT:
				match int(connection.y):
					G.CONNECTION_POINTS.TOP_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
						line.rotation_degrees = 90.0
					G.CONNECTION_POINTS.TOP_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
						line.rotation_degrees = 270.0
					G.CONNECTION_POINTS.RIGHT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
						line.rotation_degrees = 180.0
					G.CONNECTION_POINTS.RIGHT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
						line.rotation_degrees = 180.0
					G.CONNECTION_POINTS.BOTTOM_RIGHT:
						assert(false)
					G.CONNECTION_POINTS.BOTTOM_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
						line.rotation_degrees = 180.0
					G.CONNECTION_POINTS.LEFT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
						line.rotation_degrees = 270.0
					G.CONNECTION_POINTS.LEFT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
						line.rotation_degrees = 270.0
			
			# from BOTTOM_LEFT
			G.CONNECTION_POINTS.BOTTOM_LEFT:
				match int(connection.y):
					G.CONNECTION_POINTS.TOP_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
						line.rotation_degrees = 90.0
					G.CONNECTION_POINTS.TOP_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
						line.rotation_degrees = 90.0
						line.flip_h = true
					G.CONNECTION_POINTS.RIGHT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
						line.rotation_degrees = 180.0
					G.CONNECTION_POINTS.RIGHT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
						line.rotation_degrees = 270.0
						line.flip_v = true
					G.CONNECTION_POINTS.BOTTOM_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
						line.rotation_degrees = 180.0
					G.CONNECTION_POINTS.BOTTOM_LEFT:
						assert(false)
					G.CONNECTION_POINTS.LEFT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
						line.rotation_degrees = 270.0
					G.CONNECTION_POINTS.LEFT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
						line.flip_v = true
			
			# from LEFT_BOTTOM
			G.CONNECTION_POINTS.LEFT_BOTTOM:
				match int(connection.y):
					G.CONNECTION_POINTS.TOP_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					G.CONNECTION_POINTS.TOP_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
					G.CONNECTION_POINTS.RIGHT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
					G.CONNECTION_POINTS.RIGHT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
					G.CONNECTION_POINTS.BOTTOM_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
						line.rotation_degrees = 270.0
					G.CONNECTION_POINTS.BOTTOM_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
						line.rotation_degrees = 270.0
					G.CONNECTION_POINTS.LEFT_BOTTOM:
						assert(false)
					G.CONNECTION_POINTS.LEFT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
						line.rotation_degrees = 270.0
			
			# from LEFT_TOP
			G.CONNECTION_POINTS.LEFT_TOP:
				match int(connection.y):
					G.CONNECTION_POINTS.TOP_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
					G.CONNECTION_POINTS.TOP_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
						line.flip_h = true
						line.rotation_degrees = 270.0
					G.CONNECTION_POINTS.RIGHT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
						line.rotation_degrees = 180.0
					G.CONNECTION_POINTS.RIGHT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
						line.flip_v = true
					G.CONNECTION_POINTS.BOTTOM_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
						line.rotation_degrees = 270.0
					G.CONNECTION_POINTS.BOTTOM_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
						line.flip_v = true
					G.CONNECTION_POINTS.LEFT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
						line.rotation_degrees = 270.0
					G.CONNECTION_POINTS.LEFT_TOP:
						assert(false)
				
		
#		line.region_rect.position.x =
		
		line.visible = true


func get_connected_position( other: int) -> int:
	for connection in connections:
		if int(connection.x) == other:
			return int(connection.y)
		if int(connection.y) == other:
			return int(connection.x)
	
	return -1
