extends GridContainer

const PARENT_SCRIPT = "res://RPGFightFramework/scripts/modeler/mapLayout/parentScene.gd"
const MINIATURE_MAP_PATH = "res://RPGFightFramework/scenes/modeleur/MapMiniature.tscn"

var m_maps = []

func _ready():
	var viewportSize = get_viewport().get_size()
	set_custom_minimum_size(viewportSize * Vector2(0.1, 0.1))
	get_node("..").set_custom_minimum_size(viewportSize * Vector2(0.1, 0.1))
	
func addMap(var map, var nameMap = ""):
	var miniature = load(MINIATURE_MAP_PATH).instance()
	add_child(miniature)
	if nameMap == "":
		nameMap = "defaut"
	miniature.init(map, nameMap)
	miniature.get_node("VBoxContainer/TextureRect").connect("gui_input", self, "on_sprite_input")
#	scene.addParentLevelSprites(get_node("VBoxContainer/HBoxContainer/ScrollContainer/VBoxContainer"))

func refreshMiniature(var nameMap):
	var children = get_children()
	for child in children:
		if child.get_name() == nameMap:
			child.refresh()
	
func on_sprite_input(ev):
	print(ev)
	pass