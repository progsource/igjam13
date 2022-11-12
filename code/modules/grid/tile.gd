extends Control


enum CONNECTION_POINTS {
	TOP_LEFT,
	TOP_RIGHT,
	RIGHT_TOP,
	RIGHT_BOTTOM,
	BOTTOM_RIGHT,
	BOTTOM_LEFT,
	LEFT_BOTTOM,
	LEFT_TOP,
}

const CONNECTION_IMAGE_POSITION_CORNER := 2 * 32
const CONNECTION_IMAGE_POSITION_LINE_CORNER := 3 * 32
const CONNECTION_IMAGE_POSITION_OVER_CROSS := 4 * 32
const CONNECTION_IMAGE_POSITION_STRAIGHT := 5 * 32
const CONNECTION_IMAGE_POSITION_SAME_BORDER := 6 * 32
const CONNECTION_IMAGE_POSITION_FAR_CORNER := 7 * 32


var possible_connections := 1
var connections := []


func _ready():
	_reset_lines()
	_initialize_connections()
	_display_connections()


func _initialize_connections() -> void:
	var available_connections := []
	available_connections.resize(CONNECTION_POINTS.size())
	for i in range(0, CONNECTION_POINTS.size()):
		available_connections[i] = i

#	connections.append(Vector2(CONNECTION_POINTS.TOP_LEFT, CONNECTION_POINTS.TOP_RIGHT))
#	connections.append(Vector2(CONNECTION_POINTS.LEFT_TOP, CONNECTION_POINTS.LEFT_BOTTOM))
#	connections.append(Vector2(CONNECTION_POINTS.BOTTOM_LEFT, CONNECTION_POINTS.BOTTOM_RIGHT))
#	connections.append(Vector2(CONNECTION_POINTS.RIGHT_BOTTOM, CONNECTION_POINTS.RIGHT_TOP))

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


func _display_connections() -> void:
	var counter = 0
	
	for connection in connections:
		counter += 1
		var line = get_node("Background/Line%d" % [counter]) as Sprite
		
		match int(connection.x):
			# from TOP_LEFT
			CONNECTION_POINTS.TOP_LEFT:
				match int(connection.y):
					CONNECTION_POINTS.TOP_LEFT:
						assert(false)
					CONNECTION_POINTS.TOP_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
					CONNECTION_POINTS.RIGHT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					CONNECTION_POINTS.RIGHT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
					CONNECTION_POINTS.BOTTOM_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
					CONNECTION_POINTS.BOTTOM_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
					CONNECTION_POINTS.LEFT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					CONNECTION_POINTS.LEFT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
			
			# from TOP_RIGHT
			CONNECTION_POINTS.TOP_RIGHT:
				match int(connection.y):
					CONNECTION_POINTS.TOP_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
					CONNECTION_POINTS.TOP_RIGHT:
						assert(false)
					CONNECTION_POINTS.RIGHT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
					CONNECTION_POINTS.RIGHT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					CONNECTION_POINTS.BOTTOM_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
					CONNECTION_POINTS.BOTTOM_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
					CONNECTION_POINTS.LEFT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
					CONNECTION_POINTS.LEFT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
			
			# from RIGHT_TOP
			CONNECTION_POINTS.RIGHT_TOP:
				match int(connection.y):
					CONNECTION_POINTS.TOP_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					CONNECTION_POINTS.TOP_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
					CONNECTION_POINTS.RIGHT_TOP:
						assert(false)
					CONNECTION_POINTS.RIGHT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
						line.rotation_degrees = 90.0
					CONNECTION_POINTS.BOTTOM_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					CONNECTION_POINTS.BOTTOM_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
					CONNECTION_POINTS.LEFT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
					CONNECTION_POINTS.LEFT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
			
			# from RIGHT_BOTTOM
			CONNECTION_POINTS.RIGHT_BOTTOM:
				match int(connection.y):
					CONNECTION_POINTS.TOP_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
					CONNECTION_POINTS.TOP_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					CONNECTION_POINTS.RIGHT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
						line.rotation_degrees = 90.0
					CONNECTION_POINTS.RIGHT_BOTTOM:
						assert(false)
					CONNECTION_POINTS.BOTTOM_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
					CONNECTION_POINTS.BOTTOM_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					CONNECTION_POINTS.LEFT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
					CONNECTION_POINTS.LEFT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
			
			# from BOTTOM_RIGHT
			CONNECTION_POINTS.BOTTOM_RIGHT:
				match int(connection.y):
					CONNECTION_POINTS.TOP_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
					CONNECTION_POINTS.TOP_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
					CONNECTION_POINTS.RIGHT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					CONNECTION_POINTS.RIGHT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
					CONNECTION_POINTS.BOTTOM_RIGHT:
						assert(false)
					CONNECTION_POINTS.BOTTOM_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
						line.rotation_degrees = 180.0
					CONNECTION_POINTS.LEFT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					CONNECTION_POINTS.LEFT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
			
			# from BOTTOM_LEFT
			CONNECTION_POINTS.BOTTOM_LEFT:
				match int(connection.y):
					CONNECTION_POINTS.TOP_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
					CONNECTION_POINTS.TOP_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
					CONNECTION_POINTS.RIGHT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
					CONNECTION_POINTS.RIGHT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					CONNECTION_POINTS.BOTTOM_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
						line.rotation_degrees = 180.0
					CONNECTION_POINTS.BOTTOM_LEFT:
						assert(false)
					CONNECTION_POINTS.LEFT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
					CONNECTION_POINTS.LEFT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
			
			# from LEFT_BOTTOM
			CONNECTION_POINTS.LEFT_BOTTOM:
				match int(connection.y):
					CONNECTION_POINTS.TOP_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					CONNECTION_POINTS.TOP_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
					CONNECTION_POINTS.RIGHT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
					CONNECTION_POINTS.RIGHT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
					CONNECTION_POINTS.BOTTOM_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					CONNECTION_POINTS.BOTTOM_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
					CONNECTION_POINTS.LEFT_BOTTOM:
						assert(false)
					CONNECTION_POINTS.LEFT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
						line.rotation_degrees = 270.0
			
			# from LEFT_TOP
			CONNECTION_POINTS.LEFT_TOP:
				match int(connection.y):
					CONNECTION_POINTS.TOP_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_CORNER
					CONNECTION_POINTS.TOP_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					CONNECTION_POINTS.RIGHT_TOP:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_STRAIGHT
					CONNECTION_POINTS.RIGHT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_OVER_CROSS
					CONNECTION_POINTS.BOTTOM_RIGHT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_FAR_CORNER
					CONNECTION_POINTS.BOTTOM_LEFT:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_LINE_CORNER
					CONNECTION_POINTS.LEFT_BOTTOM:
						line.region_rect.position.x = CONNECTION_IMAGE_POSITION_SAME_BORDER
						line.rotation_degrees = 270.0
					CONNECTION_POINTS.LEFT_TOP:
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
