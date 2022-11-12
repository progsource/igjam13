extends Control


const CONNECTION_IMAGE_POSITION_CORNER := 2 * 32
const CONNECTION_IMAGE_POSITION_LINE_CORNER := 3 * 32
const CONNECTION_IMAGE_POSITION_OVER_CROSS := 4 * 32
const CONNECTION_IMAGE_POSITION_STRAIGHT := 5 * 32
const CONNECTION_IMAGE_POSITION_SAME_BORDER := 6 * 32
const CONNECTION_IMAGE_POSITION_FAR_CORNER := 7 * 32


var possible_connections := 4
var connections := []
export var pos := Vector2(-1, -1)


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

		line.visible = true


func get_connected_position(other: int) -> int:
	for connection in connections:
		if int(connection.x) == other:
			return int(connection.y)
		if int(connection.y) == other:
			return int(connection.x)
	
	return -1


func has_connection(connector: int, other_tile: Control, other_connector: int) -> bool:
	var additional_connector = get_connected_position(connector)
	var additional_other_connector = other_tile.get_connected_position(other_connector)
	
	if other_tile.pos.x == pos.x:
		if other_tile.pos.y == pos.y - 1:
			# self is down
			
			var is_bottom_left = other_connector == G.CONNECTION_POINTS.BOTTOM_LEFT or additional_other_connector == G.CONNECTION_POINTS.BOTTOM_LEFT
			var is_bottom_right = other_connector == G.CONNECTION_POINTS.BOTTOM_RIGHT or additional_other_connector == G.CONNECTION_POINTS.BOTTOM_RIGHT
			var is_top_left = connector == G.CONNECTION_POINTS.TOP_LEFT or additional_connector == G.CONNECTION_POINTS.TOP_LEFT
			var is_top_right = connector == G.CONNECTION_POINTS.TOP_RIGHT or additional_connector == G.CONNECTION_POINTS.TOP_RIGHT

			if not is_bottom_left and not is_bottom_right:
				return false
			elif not is_top_left and not is_top_right:
				return false
			elif (is_bottom_left and is_top_left) or (is_bottom_right and is_bottom_right):
				return true
			
			return false
		elif other_tile.pos.y == pos.y + 1:
			# self is up
			
			var is_bottom_left = connector == G.CONNECTION_POINTS.BOTTOM_LEFT or additional_connector == G.CONNECTION_POINTS.BOTTOM_LEFT
			var is_bottom_right = connector == G.CONNECTION_POINTS.BOTTOM_RIGHT or additional_connector == G.CONNECTION_POINTS.BOTTOM_RIGHT
			var is_top_left = other_connector == G.CONNECTION_POINTS.TOP_LEFT or additional_other_connector == G.CONNECTION_POINTS.TOP_LEFT
			var is_top_right = other_connector == G.CONNECTION_POINTS.TOP_RIGHT or additional_other_connector == G.CONNECTION_POINTS.TOP_RIGHT

			if not is_bottom_left and not is_bottom_right:
				return false
			elif not is_top_left and not is_top_right:
				return false
			elif (is_bottom_left and is_top_left) or (is_bottom_right and is_bottom_right):
				return true
		else:
			return false


	return false
