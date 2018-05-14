extends Node

const PLAYER_CLASS = preload("res://scripts/Fight/player.gd")
const ENEMI_CLASS = preload("res://scripts/Fight/enemi.gd")
const SCENE_FIGHT_CLASS = preload("res://scripts/Fight/sceneFight.gd")
const MENU_ACTION_SCENE = preload("res://scenes/Fight/menuActionsFight.tscn")
const CARACTERISTIC_MENU_SCENE = preload("res://scenes/Fight/caracteristicsMenu.tscn")

func _ready():
	set_name("scene_fight_perso")
	#base de test : ( a supprimer )
	
	var caracteristics = {
	"attack" : 3,
	"defense" : 1,
	"perception" : 0,
	"dexterity" : 0,
	"agility" : 0,
	"strength" : 0,
	"state" : [],
	"life" : 20,
	"nbMoves" : 3,
	"orientation" : Vector3(1,0,0)
	}

	var characters = []
	var mesh = load("res://scenes/Fight/leo.tscn").instance()
	mesh.transform.origin += (Vector3(-10,0.5,-10) - mesh.transform.origin)
	var character = PLAYER_CLASS.new("leo", Vector3(0,0,0), ["attack", "cross", "posterize", "up_and_down", "steal", "deplacement", "passe", "passer"], "Players", caracteristics, MENU_ACTION_SCENE, mesh)
	var caracteristicsMenu = CARACTERISTIC_MENU_SCENE.instance()
	caracteristicsMenu.init(character, caracteristics)
	add_child(caracteristicsMenu)
	
	characters.append(character)
	
	caracteristics = {
	"attack" : 3,
	"defense" : 1,
	"perception" : 0,
	"dexterity" : 0,
	"agility" : 0,
	"strength" : 0,
	"state" : [],
	"life" : 20,
	"nbMoves" : 3,
	"orientation" : Vector3(1,0,0)
	}
	mesh = load("res://scenes/Fight/blond.tscn").instance()
	mesh.transform.origin += (Vector3(-10,0.5,-10) - mesh.transform.origin)
	character = PLAYER_CLASS.new("blond", Vector3(0,0,0), ["attack", "steal", "deplacement", "passe", "block", "passer"], "Players", caracteristics, MENU_ACTION_SCENE, mesh)
	
	caracteristicsMenu = CARACTERISTIC_MENU_SCENE.instance()
	caracteristicsMenu.init(character, caracteristics)
	add_child(caracteristicsMenu)
	
	characters.append(character)
	
	caracteristics = {
	"attack" : 3,
	"defense" : 1,
	"perception" : 0,
	"dexterity" : 0,
	"agility" : 0,
	"strength" : 0,
	"state" : [],
	"life" : 20,
	"nbMoves" : 3,
	"orientation" : Vector3(1,0,0)
	}
	mesh = load("res://scenes/Fight/mechant.tscn").instance()
	mesh.transform.origin += (Vector3(-10,0.5,-10) - mesh.transform.origin)
	character = ENEMI_CLASS.new("ennemi", Vector3(0,0,0), ["attack", "cross", "passer"], "Enemis", caracteristics, mesh)
	
	caracteristicsMenu = CARACTERISTIC_MENU_SCENE.instance()
	caracteristicsMenu.init(character, caracteristics)
	add_child(caracteristicsMenu)
	
	characters.append(character)
	
	var objects = []
	var selectables = []
	for c in characters:
		selectables.append(c)
	for o in objects:
		selectables.append(o)
	var map = load("res://scenes/Fight/map_example2.tscn").instance()
	var scene = SCENE_FIGHT_CLASS.new("res://scripts/Fight/actionPerso.gd", map, selectables)
	add_child(scene)