tool
extends Button


export var is_left := false


var row := -1


func _ready():
	if is_left:
		$Sprite.flip_h = true
	
	# warning-ignore:return_value_discarded
	connect("button_up", self, "_on_arrow_pressed")
	
	# warning-ignore:return_value_discarded
	G.connect("arrow_buttons_enabled", self, "_on_arrow_buttons_enabled")
	
# warning-ignore:return_value_discarded
	G.connect("game_state_updated", self, "_on_game_state_updated")


func _on_arrow_pressed():
	G.emit_signal("arrow_button_pressed", row, is_left)


func _on_arrow_buttons_enabled(enabled: bool) -> void:
	disabled = !enabled
	modulate.a = 1.0 if enabled else 0.5


func _on_game_state_updated() -> void:
	if G.current_game_state == G.GAME_STATE.PC_ROW_TURN:
		_on_arrow_buttons_enabled(true)
