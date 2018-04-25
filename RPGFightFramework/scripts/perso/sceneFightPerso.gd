extends Node

const TILESIZE = 0.1
const PLAYER_CLASS = preload("res://RPGFightFramework/scripts/perso/player.gd")
const ENEMI_CLASS = preload("res://RPGFightFramework/scripts/perso/enemi.gd")
const SCENE_FIGHT_CLASS = preload("res://RPGFightFramework/scripts/sceneFight.gd")
var CARACTERISTIC_MENU_CLASS = preload("res://RPGFightFramework/perso/scenes/caracteristicsMenu.tscn")

func _ready():
	set_name("scene_figh_ perso")
	#Taille de la tile de la map en fonction de la taille de du viewport
	var tileSize = get_viewport().get_size().y * TILESIZE
	#base de test : ( a supprimer )
	
	var caracteristics = {
	"attack" : 3,
	"defense" : 1,
	"perception" : 0,
	"dexterity" : 0,
	"agility" : 0,
	"strenght" : 0,
	"state" : [],
	"life" : 20,
	"nbMoves" : 3,
	"orientation" : Vector3(1,0,0)
	}

	var characters = []
	var mesh = load("res://RPGFightFramework/scenes/perso/leo.tscn").instance()
	mesh.set_scale(Vector3(0.5,0.5,0.5))
	var character = PLAYER_CLASS.new("leo", Vector2(0,0), ["attack", "cross", "steal", "deplacement", "passe", "passer"], "Players", caracteristics, "res://RPGFightFramework/scripts/menuActionsFight.gd", mesh)
	var caracteristicsMenu = CARACTERISTIC_MENU_CLASS.instance()
	caracteristicsMenu.init(character, caracteristics)
	add_child(caracteristicsMenu)
	
	characters.append(character)
	
	caracteristics = {
	"attack" : 3,
	"defense" : 1,
	"perception" : 0,
	"dexterity" : 0,
	"agility" : 0,
	"strenght" : 0,
	"state" : [],
	"life" : 20,
	"nbMoves" : 3,
	"orientation" : Vector3(1,0,0)
	}
	mesh = load("res://RPGFightFramework/scenes/perso/blond.tscn").instance()
	mesh.set_scale(Vector3(0.5,0.5,0.5))
	character = PLAYER_CLASS.new("blond", Vector2(0,0), ["attack", "steal", "deplacement", "passe", "block", "passer"], "Players", caracteristics, "res://RPGFightFramework/scripts/menuActionsFight.gd", mesh)
	
	caracteristicsMenu = CARACTERISTIC_MENU_CLASS.instance()
	caracteristicsMenu.init(character, caracteristics)
	add_child(caracteristicsMenu)
	
	characters.append(character)
	
	caracteristics = {
	"attack" : 3,
	"defense" : 1,
	"perception" : 0,
	"dexterity" : 0,
	"agility" : 0,
	"strenght" : 0,
	"state" : [],
	"life" : 20,
	"nbMoves" : 3,
	"orientation" : Vector3(1,0,0)
	}
	mesh = load("res://RPGFightFramework/scenes/perso/mechant.tscn").instance()
	mesh.set_scale(Vector3(0.5,0.5,0.5))
	character = ENEMI_CLASS.new("ennemi", Vector2(0,0), ["attack", "cross", "passer"], "Enemis", caracteristics, mesh)
	
	caracteristicsMenu = CARACTERISTIC_MENU_CLASS.instance()
	caracteristicsMenu.init(character, caracteristics)
	add_child(caracteristicsMenu)
	
	characters.append(character)
	
	var objects = []
	var selectables = []
	for c in characters:
		selectables.append(c)
	for o in objects:
		selectables.append(o)
	var map = load("res://RPGFightFramework/map_modeler/map_example.tscn").instance()
	var scene = SCENE_FIGHT_CLASS.new("res://RPGFightFramework/scripts/perso/actionPerso.gd", map, "res://RPGFightFramework/scripts/mapMatrix3D.gd", "res://RPGFightFramework/scripts/turn.gd", selectables)
	add_child(scene)
	#fin base de test
	.set_process(true)