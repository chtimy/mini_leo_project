extends GridContainer

########################################################################################################################################
###################################################		MEMBERS	########################################################################
########################################################################################################################################
export (PackedScene) var MINIATURE_MAP_SCENE = preload("res://RPGFightFramework/scenes/modeleur/MapMiniature.tscn")
export (int) var m_defaultNumber = 0
	
func addMap(var map, var nameMap = ""):
	var miniature = MINIATURE_MAP_SCENE.instance()
	add_child(miniature)
	if nameMap == "":
		nameMap = "defaut" + String(m_defaultNumber)
		m_defaultNumber += 1
	miniature.init(map, nameMap)

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