extends Node2D

const TILESIZE = 0.1

var m_actionsDico = { }
var m_characters = []
var m_objects = []
var m_map
var m_selectables = []
var m_tileSize
var m_turnHandler

var ReaderScript = load("res://RPGFightFramework/scripts/reader.gd").new()

#func _ready():
#	#Taille de la tile de la map en fonction de la taille de du viewport
#	m_tileSize = get_viewport().get_size().y * TILESIZE
#	#base de test : ( a supprimer )
#	var characters = []
#	var character = load("res://RPGFightFramework/scripts/perso/player.gd").new()
#	character.init("leo", Vector2(0,0), ["cross", "posterize", "deplacer"], "Players", m_tileSize, ["res://images/map/fightScene/character.png"], 5, 20, 20, 3, "normal", get_node("."))
#	characters.append(character)
#	character = load("res://RPGFightFramework/scripts/perso/player.gd").new()
#	character.init("ennemi", Vector2(0,0), ["cross"], "Enemis", m_tileSize, ["res://images/map/fightScene/ennemi.png"], 2, 20, 20, 2, "normal", get_node("."))
#	characters.append(character)
#	var objects = []
#	var selectables = []
#	for c in characters:
#		selectables.append(c)
#	for o in objects:
#		selectables.append(o)
#
#	init("res://data/fightScene/mapFight01.txt", "res://RPGFightFramework/scripts/turn.gd", selectables)
#	#fin base de test
#	set_process(true)

# @function : init
# @Description : initialisation de la scène de combat 
# @params :
#	mapFilePath : Chemin vers un fichier map
#	selectables : tableau de selectionnables
func init(var mapFilePath, var turnScriptPath, var selectables, var viewportSize):
	# action generation
	m_actionsDico = load("res://RPGFightFramework/scripts/perso/actionPerso.gd").new()
	if !m_actionsDico.init(ReaderScript):
		print("Error : Liste d'actions impossible a initialiser")
	#map generation
	m_map = Node2D.new()
	var script = load("res://RPGFightFramework/scripts/fightMap.gd")
	if script == null:
		print("Error : le script n'a pas pu être chargée : ", "res://RPGFightFramework/scripts/fightMap.gd")
	else :
		m_map.set_script(script)
		m_map.init(mapFilePath , Vector2(m_tileSize, m_tileSize), ReaderScript)
		add_child(m_map)
		#Generation des selectables
		var i = 0
		var j = 0
		for selectable in selectables:
			if selectable.isCategory("Players"):
				selectable.setPosition(m_map.m_initialPositions[0][i])
				j += 1
				selectable.initMenu(get_node("."), m_actionsDico, viewportSize)
				m_characters.append(selectable)
			elif selectable.isCategory("Enemis"):
				selectable.setPosition(m_map.m_initialPositions[1][i])
				i += 1
				m_characters.append(selectable)
			else :
				m_objects.append(selectable)
			add_child(selectable)
		m_turnHandler = load(turnScriptPath)
		if m_turnHandler == null:
			print("Error : Impossible to load Turn handler script : \"", turnScriptPath, "\"")
		else:
			m_turnHandler = m_turnHandler.new()
			m_turnHandler.init(m_characters, m_objects, m_actionsDico, m_map)

func _process(delta):
	m_turnHandler.play()
	
func getTileSize():
	return m_tileSize
func getActionsDico():
	return m_actionsDico