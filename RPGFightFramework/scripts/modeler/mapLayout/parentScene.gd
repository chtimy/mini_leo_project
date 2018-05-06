extends TextureRect

signal sprite_input

var m_parent = null
	
func _gui_input(var event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed == false:
			emit_signal("sprite_input", self)