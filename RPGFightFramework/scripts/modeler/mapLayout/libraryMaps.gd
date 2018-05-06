extends GridContainer

const PARENT_SCRIPT = "res://RPGFightFramework/scripts/modeler/mapLayout/parentScene.gd"
const MINIATURE_MAP_PATH = 

var m_maps = []

func addMap(var map):
	
	var viewport = Viewport.new()
	viewport.add_child(map)
	var sprite = TextureRect.new()
	sprite.set_texture(viewport.get_texture())
	viewport.remove_child(map)
	viewport.queue_free()
	
	var viewportSize = get_viewport().get_size()
	sprite.set_expand(true)
	scene.get_node("..").set_custom_minimum_size(viewportSize * Vector2(0.1, 0.1))
	sprite.set_custom_minimum_size(viewportSize * Vector2(0.1, 0.1))
#	sprite.set_script(load(PARENT_SCRIPT))
#	sprite.m_parent = self
	sprite.connect("sprite_input", self, "on_sprite_input")
	add_child(sprite)
	scene.addParentLevelSprites(get_node("VBoxContainer/HBoxContainer/ScrollContainer/VBoxContainer"))
	
func on_sprite_input():
	pass