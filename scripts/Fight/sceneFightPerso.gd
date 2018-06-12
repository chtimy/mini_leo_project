extends Object

const PLAYER_CLASS = preload("res://scripts/Fight/player.gd")
const ENEMI_CLASS = preload("res://scripts/Fight/enemi.gd")
const OBJECT_CLASS = preload("res://scripts/Fight/object.gd")

var selectables = []
var map

func _init():
	#base de test : ( a supprimer )	
	self.map = load("res://scenes/Fight/dungeon_map.tscn").instance()

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
	"orientation" : Vector2(1,0)
	}

	var animation = load("res://scenes/Fight/characters/MiniLeo.tscn").instance()
	var selectable = PLAYER_CLASS.new("leo",
									["Players"],
									caracteristics,
									Vector2(0,0), 
									["attack", "cross", "posterize", "up_and_under", "steal", "deplacement", "passe", "passer", "ramasser"], 
									["opportunity_attack"], 
									map, 
									load("res://ressources/images/fight/leo_tile.png"))
	selectable.add_child(animation)
	selectables.append(selectable)
	
	
	
	animation = load("res://scenes/Fight/objects/Bow.tscn").instance()
	selectable = OBJECT_CLASS.new("bow",
								["Objects"],
								{},
								Vector2(0,0),
								map)
	selectable.add_child(animation)
	selectables[0].take_in_hand(selectable)
#	selectables.append(selectable)

	caracteristics = {
	"attack" : 3,
	"defense" : 1,
	"perception" : 30,
	"dexterity" : 0,
	"agility" : 40,
	"strength" : 0,
	"state" : [],
	"life" : 20,
	"nbMoves" : 3,
	"orientation" : Vector2(1,0)
	}
	
	animation = load("res://scenes/Fight/characters/Jerem.tscn").instance()
	selectable = PLAYER_CLASS.new("jerem",
									["Players"],
									caracteristics,
									Vector2(0,0), 
									["attack", "cross", "posterize", "up_and_under", "steal", "deplacement", "passe", "passer", "ramasser"], 
									["opportunity_attack"], 
									map, 
									load("res://ressources/images/fight/leo_tile.png"))
	selectable.add_child(animation)
	selectables.append(selectable)
	
	caracteristics = {
		"attack" : 3,
		"defense" : 1,
		"perception" : 30,
		"dexterity" : 0,
		"agility" : 40,
		"strength" : 0,
		"state" : [],
		"life" : 20,
		"nbMoves" : 3,
		"orientation" : Vector2(1,0)
		}
	
	animation = load("res://scenes/Fight/characters/GB.tscn").instance()
	selectable = PLAYER_CLASS.new("GB",
									["Players"],
									caracteristics,
									Vector2(0,0), 
									["attack", "cross", "posterize", "up_and_under", "steal", "deplacement", "passe", "passer", "ramasser"], 
									["opportunity_attack"], 
									map, 
									load("res://ressources/images/fight/leo_tile.png"))
	selectable.add_child(animation)
	selectables.append(selectable)
	
	caracteristics = {
	"attack" : 3,
	"defense" : 1,
	"perception" : 0,
	"dexterity" : 0,
	"agility" : 30,
	"strength" : 0,
	"state" : [],
	"life" : 20,
	"nbMoves" : 3,
	"orientation" : Vector2(1,0)
	}
	animation = load("res://scenes/Fight/characters/Enemi.tscn").instance()
	selectable = ENEMI_CLASS.new("ennemi", 
								["Enemis"], 
								caracteristics, 
								Vector2(0,0), 
								["attack", "cross", "passer", "ramasser"], 
								["opportunity_attack"], 
								map,
								load("res://ressources/images/fight/enemi_tile.png"))
	selectable.add_child(animation)
	selectables.append(selectable)



	
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
	"orientation" : Vector2(1,0)
	}
	animation = load("res://scenes/Fight/characters/Blond.tscn").instance()
	selectable = PLAYER_CLASS.new("blond", 
								["Players"], 
								caracteristics, 
								Vector2(0,0), 
								["attack", "steal", "deplacement", "passe", "block", "passer", "ramasser"], 
								["opportunity_attack"], 
								map,
								load("res://ressources/images/fight/blond_tile.png"))
	selectable.add_child(animation)
	selectables.append(selectable)
	