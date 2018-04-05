extends "res://RPGFightFramework/scripts/sceneFight.gd"

const TILESIZE = 0.1

var ReaderScript = load("res://RPGFightFramework/scripts/reader.gd").new()

func _ready():
	#Taille de la tile de la map en fonction de la taille de du viewport
	m_tileSize = get_viewport().get_size().y * TILESIZE
	#base de test : ( a supprimer )
	var characters = []
	var character = load("res://RPGFightFramework/scripts/perso/player.gd").new()
	character.init("leo", Vector2(0,0), ["cross", "posterize", "deplacer"], "Players", m_tileSize, ["res://images/map/fightScene/character.png"], 5, 20, 20, 3, "normal", get_node("."))
	characters.append(character)
	character = load("res://RPGFightFramework/scripts/perso/player.gd").new()
	character.init("ennemi", Vector2(0,0), ["cross"], "Enemis", m_tileSize, ["res://images/map/fightScene/ennemi.png"], 2, 20, 20, 2, "normal", get_node("."))
	characters.append(character)
	var objects = []
	var selectables = []
	for c in characters:
		selectables.append(c)
	for o in objects:
		selectables.append(o)
	
	.init("res://data/fightScene/mapFight01.txt", "res://RPGFightFramework/scripts/turn.gd", selectables)
	#fin base de test
	.set_process(true)