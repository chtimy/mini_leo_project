extends GridContainer

const PARENT_SCRIPT = "res://RPGFightFramework/scripts/modeler/mapLayout/parentScene.gd"
const MINIATURE_MAP_PATH = "res://RPGFightFramework/scenes/modeleur/MapMiniature.tscn"

var m_defaultNumber = 0

var m_maps = []

func _ready():
	var viewportSize = get_viewport().get_size()
	set_custom_minimum_size(viewportSize * Vector2(0.1, 0.1))
	get_node("..").set_custom_minimum_size(viewportSize * Vector2(0.1, 0.1))
	
func addMap(var map, var nameMap = ""):
	var miniature = load(MINIATURE_MAP_PATH).instance()
	add_child(miniature)
	if nameMap == "":
		nameMap = "defaut" + String(m_defaultNumber)
		m_defaultNumber += 1
	miniature.init(map, nameMap)
#	scene.addParentLevelSprites(get_node("VBoxContainer/HBoxContainer/ScrollContainer/VBoxContainer"))

func refreshMiniature(var map, var screenshot):
	var children = get_children()
	for child in children:
		if child.get_name() == map.get_name():
			child.refresh(screenshot)
			
func getListMapNames():
	var list = []
	for child in get_children():
		list.append(child.get_name())
	return list
	
func getMap(var nameMap):
	for child in get_children():
		if child.get_name() == nameMap:
			return child.m_map
	return null