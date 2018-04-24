extends Node

var m_actionsDico = { }
var m_characters = []
var m_objects = []
var m_map
var m_selectables = []
var m_tileSize
var m_turnHandler

# @function : init
# @Description : initialisation de la scène de combat 
# @params :
#	mapFilePath : Chemin vers un fichier map
#	selectables : tableau de selectionnables
func _init(var actionsFilePath, var map, var mapScriptPath, var turnScriptPath, var selectables):
	var MAP_CLASS = load(mapScriptPath)
	var TURN_CLASS = load(turnScriptPath)
	var ACTIONS_CLASS = load(actionsFilePath)
	
	if TURN_CLASS and MAP_CLASS and ACTIONS_CLASS:
		m_actionsDico = ACTIONS_CLASS.new()
		m_map = MAP_CLASS.new(map)
		var overlayScene = load("res://RPGFightFramework/scenes/perso/overlay.tscn")
		m_map.setOverlayMesh(overlayScene)
		var cursorScene = load("res://RPGFightFramework/scenes/perso/cursor.tscn")
		m_map.setCursorMesh(cursorScene)
		m_selectables = selectables
		
		#Generation des selectables
		var position
		for selectable in m_selectables:
			if selectable.isCategory("Objects"):
				m_objects.append(selectable)
			else:
				if selectable.isCategory("Players"):
					selectable.initMenu(m_actionsDico)
					position = m_map.getNextPlayerInitPosition()
				else:
					position = m_map.getNextEnemiInitPosition()
				m_characters.append(selectable)
			m_map.setSelectable(selectable, position)
			selectable.setPosition(position, m_map)
		m_turnHandler = TURN_CLASS.new(m_characters, m_objects, m_actionsDico, m_map)
	else:
		print("Error : Impossible to load all the scripts")
	
func getTileSize():
	return m_tileSize
func getActionsDico():
	return m_actionsDico
	
func _ready():
	self.set_name("sceneFight")
	add_child(m_map)
	#Generation des selectables
	var i = 0
	var j = 0
	for selectable in m_selectables:
		#selectable.initMenu(get_node("."), m_actionsDico, viewportSize)
		add_child(selectable)

func _process(delta):
	m_turnHandler.play()