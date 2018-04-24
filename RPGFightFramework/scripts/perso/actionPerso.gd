extends "res://RPGFightFramework/scripts/actions.gd"

func _init().():
	pass

#here write all actions (range, effects)
func deplacementAction(var game, var move):
	print("deplacerAction")
	#game.moveSelectable(character.m_position, game.currentCharacter().m_position + move)
	#game.currentCharacter().m_position += move
	
func deplacementRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	#print("deplacerRange")
	var character = characters[currentCharacterIndex]
	if character.m_position.x + character.m_caracteristics.nbMoves >= position.x && character.m_position.x - character.m_caracteristics.nbMoves <= position.x 	&& character.m_position.y + character.m_caracteristics.nbMoves >= position.y && character.m_position.y - character.m_caracteristics.nbMoves <= position.y 	&& !toolFunctions["is_something_there"].call_func(characters, position) && !toolFunctions["is_something_there"].call_func(objects, position):
		return true
	return false
func deplacementCondition(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	return true

func posterizeAction(var character, var enemi):
	print("posterizeAction")
	enemi.takeDamages(character.m_attackPourcentage)
	enemi.applyEffect("stunt")
func posterizeRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	#print("posterizeRange")
	var character = characters[currentCharacterIndex]
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.y == position.y) || (character.m_position.y + 1 >= position.y && character.m_position.y - 1 <= position.y && character.m_position.x == position.x)) && toolFunctions["is_enemi_there"].call_func(characters, position):
		return true
	return false
func posterizeCondition(var game):
	var success = false
	var map = game.map
	var neighbor = map.getNeighbor(1, map.STRAIGHT)
	for neighbour in neighbor:
		if game.currentCharacter().isFaceToFace(neighbour):
			success = true
			game.enableFocusedCharacter(neighbour)
	return success

func crossAction(var character, var enemi):
	print("crossAction")
	
func crossRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	#print("crossRange")
	var character = characters[currentCharacterIndex]
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.y == position.y) || (character.m_position.y + 1 >= position.y && character.m_position.y - 1 <= position.y && character.m_position.x == position.x)) && toolFunctions["is_enemi_there"].call_func(characters, position):
		return true
	return false
func crossCondition(var game):
	var success = false
#	var map = game.map
#	var neighbor = map.getNeighbor(1, map.STRAIGHT)
#	for neighbour in neighbor:
#		if game.currentCharacter().isFaceToFace(neighbour) and map.isFreeCase(neighbour,  :
#			success = true
#			game.enableFocusedCharacter(neighbour)
#	return success

func stealAction(var character, var enemi):
	print("stealAction")
	character.steal(enemi)
func stealRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	var character = characters[currentCharacterIndex]
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.y == position.y) || (character.m_position.y + 1 >= position.y && character.m_position.y - 1 <= position.y && character.m_position.x == position.x)) && toolFunctions["is_enemi_there"].call_func(characters, position):
		return true
	return false
	
func blockAction(var character):
	print("blockAction")
	character.applyEffect("block")
func blockRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	var character = characters[currentCharacterIndex]
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.y == position.y) || (character.m_position.y + 1 >= position.y && character.m_position.y - 1 <= position.y && character.m_position.x == position.x)) && toolFunctions["is_enemi_there"].call_func(characters, position):
		return true
	return false
	
func from_downtownAction(var character, var enemi):
	print("from downtown Action")
	character.attack(enemi)
func from_downtownRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	var character = characters[currentCharacterIndex]
	if character.m_position.x + character.m_caracteristics.nbMoves >= position.x && character.m_position.x - character.m_caracteristics.nbMoves <= position.x 	&& character.m_position.y + character.m_caracteristics.nbMoves >= position.y && character.m_position.y - character.m_caracteristics.nbMoves <= position.y 	&& !toolFunctions["is_something_there"].call_func(characters, position) && !toolFunctions["is_something_there"].call_func(objects, position):
		return true
	return false
	
func up_and_downAction(var character, var enemi):
	print("up and down Action")
	character.attack(enemi)
func up_and_downRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	var character = characters[currentCharacterIndex]
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.y == position.y) || (character.m_position.y + 1 >= position.y && character.m_position.y - 1 <= position.y && character.m_position.x == position.x)) && toolFunctions["is_enemi_there"].call_func(characters, position):
		return true
	return false
	
func passeAction(var character, var receiver_character):
	print("passe Action")
	character.pass(receiver_character)
func passeRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	var character = characters[currentCharacterIndex]
	if character.m_position.x + character.m_caracteristics.nbMoves >= position.x && character.m_position.x - character.m_caracteristics.nbMoves <= position.x 	&& character.m_position.y + character.m_caracteristics.nbMoves >= position.y && character.m_position.y - character.m_caracteristics.nbMoves <= position.y 	&& !toolFunctions["is_something_there"].call_func(characters, position) && !toolFunctions["is_something_there"].call_func(objects, position):
		return true

#attention character c'est m_position
func is_something_there(var things, var position):
	for thing in things:
		if position.x == thing.m_position.x && position.y == thing.m_position.y:
			return true
	return false

func is_enemi_there(var characters, var position):
	for character in characters:
		if character.m_category == "Enemis" && position.x == character.m_position.x && position.y == character.m_position.y:
			return true
	return false