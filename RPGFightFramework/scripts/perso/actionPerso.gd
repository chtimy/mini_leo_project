extends "res://RPGFightFramework/scripts/actions.gd"

func _init().():
	pass

#here write all actions (range, effects)
static func deplacementAction(var game, var positionTo):
	print("deplacerAction")
	game.currentPlayingCharacter().setPosition(positionTo, game.getMap())
static func deplacementRange(var characters, var currentCharacterIndex, var objects, var map, var position, var toolFunctions):
	#print("deplacerRange")
	var character = characters[currentCharacterIndex]
	if character.m_position.x + character.m_caracteristics.nbMoves >= position.x && character.m_position.x - character.m_caracteristics.nbMoves <= position.x && character.m_position.z + character.m_caracteristics.nbMoves >= position.z && character.m_position.z - character.m_caracteristics.nbMoves <= position.z && !toolFunctions["is_something_there"].call_func(characters, position) && !toolFunctions["is_something_there"].call_func(objects, position) and map.on_surface(position):
		return true
	return false
static func deplacementCondition(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	return true

static func posterizeAction(var game, var enemi):
	print("posterizeAction")
	var character = game.currentPlayingCharacter()
	enemi.decreaseCaracteristic("life", character.getCaracteristic("attack"))
	if character.throwDiceForCaracteristic("strength"):
		enemi.addCaracteristic("state", {"stunt": 1})
static func posterizeRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	#print("posterizeRange")
	var character = characters[currentCharacterIndex]
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.z == position.z) || (character.m_position.z + 1 >= position.z && character.m_position.z - 1 <= position.z && character.m_position.z == position.x)) && toolFunctions["is_enemi_there"].call_func(characters, position):
		return true
	return false
static func posterizeCondition(var game):
	var success = false
	var map = game.map
	var neighbor = map.getNeighbor(1, map.STRAIGHT)
	for neighbour in neighbor:
		if game.currentCharacter().isFaceToFace(neighbour):
			success = true
			game.enableFocusedCharacter(neighbour)
	return success

static func crossAction(var game, var positionTo):
	print("crossAction")
static func crossRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	#print("crossRange")
	var character = characters[currentCharacterIndex]
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.z == position.z) || (character.m_position.z + 1 >= position.z && character.m_position.z - 1 <= position.z && character.m_position.x == position.x)) && toolFunctions["is_enemi_there"].call_func(characters, position):
		return true
	return false
static func crossCondition(var game):
	var success = false
#	var map = game.map
#	var neighbor = map.getNeighbor(1, map.STRAIGHT)
#	for neighbour in neighbor:
#		if game.currentCharacter().isFaceToFace(neighbour) and map.isFreeCase(neighbour,  :
#			success = true
#			game.enableFocusedCharacter(neighbour)
#	return success

static func stealAction(var game, var enemi):
	print("stealAction")
#	character.steal(enemi)
static func stealRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	var character = characters[currentCharacterIndex]
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.z == position.z) || (character.m_position.z + 1 >= position.z && character.m_position.z - 1 <= position.z && character.m_position.x == position.x)) && toolFunctions["is_enemi_there"].call_func(characters, position):
		return true
	return false
	
static func blockAction(var game):
	print("blockAction")
	var character = game.currentPlayingCharacter()
	enemi.addCaracteristic("state", {"block": 1})
static func blockRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	var character = characters[currentCharacterIndex]
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.z == position.z) || (character.m_position.z + 1 >= position.z && character.m_position.z - 1 <= position.z && character.m_position.x == position.x)) && toolFunctions["is_enemi_there"].call_func(characters, position):
		return true
	return false
	
static func from_downtownAction(var game, var enemi):
	print("from downtown Action")
	
static func from_downtownRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	var character = characters[currentCharacterIndex]
	if character.m_position.x + character.m_caracteristics.nbMoves >= position.x && character.m_position.x - character.m_caracteristics.nbMoves <= position.x && character.m_position.z + character.m_caracteristics.nbMoves >= position.z && character.m_position.z - character.m_caracteristics.nbMoves <= position.z && !toolFunctions["is_something_there"].call_func(characters, position) && !toolFunctions["is_something_there"].call_func(objects, position):
		return true
	return false
	
static func up_and_downAction(var game, var enemi):
	print("up and down Action")
#	character.attack(enemi)
static func up_and_downRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	var character = characters[currentCharacterIndex]
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.z == position.z) || (character.m_position.z + 1 >= position.z && character.m_position.z - 1 <= position.z && character.m_position.x == position.x)) && toolFunctions["is_enemi_there"].call_func(characters, position):
		return true
	return false
	
static func passeAction(var game, var receiver_character):
	print("passe Action")
#	character.pass(receiver_character)
static func passeRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	var character = characters[currentCharacterIndex]
	if character.m_position.x + character.m_caracteristics.nbMoves >= position.x && character.m_position.x - character.m_caracteristics.nbMoves <= position.x && character.m_position.z + character.m_caracteristics.nbMoves >= position.z && character.m_position.z - character.m_caracteristics.nbMoves <= position.z 	&& !toolFunctions["is_something_there"].call_func(characters, position) && !toolFunctions["is_something_there"].call_func(objects, position):
		return true

#attention character c'est m_position
static func is_something_there(var things, var position):
	for thing in things:
		if position.x == thing.m_position.x && position.z == thing.m_position.z:
			return true
	return false

static func is_enemi_there(var characters, var position):
	for character in characters:
		if character.m_category == "Enemis" && position.x == character.m_position.x && position.z == character.m_position.z:
			return true
	return false