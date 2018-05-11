extends Control

var TOOLS = preload("res://RPGFightFramework/scripts/modeler/tools.gd")

signal changeMap

var m_map

func init(var map, var nameMap):
	set_name(nameMap)
	m_map = map
	m_map.set_name(nameMap)
	get_node("VBoxContainer/Label").set_text(nameMap)
	
	var viewport = map.get_parent()
	#tuto godot
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	# Let two frames pass to make sure the screen was captured
	# chelou
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	# Retrieve the captured image
	var img = viewport.get_texture().get_data()
	# Flip it on the y-axis (because it's flipped)
	img.flip_y()
	# Create a texture for it
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	
	var viewportSize = get_viewport().get_size()
	var sprite = get_node("VBoxContainer/TextureRect")
	sprite.set_texture(tex)
	sprite.set_expand(true)
	sprite.set_custom_minimum_size(viewportSize * Vector2(0.1, 0.1))
	set_custom_minimum_size(viewportSize * Vector2(0.1, 0.1) + Vector2(0, get_node("VBoxContainer/Label").get_minimum_size().y))
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ALWAYS)
	connect("changeMap", TOOLS.searchParentNodeRecursive(self, "MapLayout"), "_on_changeMap")

func refresh(var screenshot):
	get_node("VBoxContainer/TextureRect").set_texture(screenshot)

func _on_VBoxContainer_gui_input(ev):
	if ev is InputEventMouseButton:
		if ev.get_button_index() == BUTTON_LEFT && ev.pressed == false:
			accept_event()
			emit_signal("changeMap", m_map)
