extends Object

const PLAYER_CLASS = preload("res://scripts/Fight/player.gd")
const ENEMI_CLASS = preload("res://scripts/Fight/enemi.gd")

var selectables = []
var map

func _init():
	#base de test : ( a supprimer )	
	self.map = load("res://scenes/Fight/map_example2.tscn").instance()

	var caracteristics = {
	"attack" : 3,
	"defense" : 1,
	"perception" : 30,
	"dexterity" : 0,
	"agility" : 40,
	"strength" : 0,
	"state" : [],
	"life" : 20,
	"nbMoves" : 3,
	"orientation" : Vector3(1,0,0)
	}

	var characters = []
	var mesh = load("res://scenes/Fight/leo.tscn").instance()
	mesh.transform.origin += (Vector3(-10,0.5,-10) - mesh.transform.origin)
	var character = PLAYER_CLASS.new("leo",
									["Players"],
									caracteristics,
									Vector3(0,0,0), 
									["attack", "cross", "posterize", "up_and_down", "steal", "deplacement", "passe", "passer"], 
									["opportunity_attack"], 
									mesh, 
									map, 
									load("res://ressources/images/mini_leo/face.png"))
	
	
	selectables.append(character)
	
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
	character = PLAYER_CLASS.new("blond", 
								["Players"], 
								caracteristics, 
								Vector3(0,0,0), 
								["attack", "steal", "deplacement", "passe", "block", "passer"], 
								["opportunity_attack"], 
								mesh, 
								map,
								load("res://ressources/images/characters/blond/blond.png"))
	
	selectables.append(character)
	
	caracteristics = {
	"attack" : 3,
	"defense" : 1,
	"perception" : 40,
	"dexterity" : 0,
	"agility" : 30,
	"strength" : 0,
	"state" : [],
	"life" : 20,
	"nbMoves" : 3,
	"orientation" : Vector3(1,0,0)
	}
	mesh = load("res://scenes/Fight/mechant.tscn").instance()
	mesh.transform.origin += (Vector3(-10,0.5,-10) - mesh.transform.origin)
	character = ENEMI_CLASS.new("ennemi", 
								["Enemis"], 
								caracteristics, 
								Vector3(0,0,0), 
								["attack", "cross", "passer"], 
								["opportunity_attack"], 
								mesh, 
								map,
								load("res://ressources/images/map/fightScene/ennemi.png"))
	
	selectables.append(character)