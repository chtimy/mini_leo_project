extends Node

var m_actions = {
	}
var m_toolFunctions = {
	}

func init(var ReaderScript):
	var descrActions = ReaderScript.readActionsFile()
	if descrActions != null:
		collectActions(descrActions)
		return true
	return false
	
func collectActions(var descrActions):
	for descrAction in descrActions.values():
		var s = descrAction.name + "Action"
		var s2 = descrAction.name + "Range"
		m_actions[descrAction.name] = {name = descrAction.name, 
									   id = descrAction.id, 
									   pathToTextures = descrAction.pathToTexture, 
									   type = descrAction.type,
									   target = descrAction.target, 
									   effects = descrAction.effects,
									   process = funcref(get_script(), s), 
									   rangeCond = funcref(get_script(), s2)}
	m_toolFunctions["is_something_there"] = funcref(get_script(), "is_something_there")
	m_toolFunctions["is_enemi_there"] = funcref(get_script(), "is_enemi_there")
		
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
		
#here write all actions (range, effects)
func deplacerAction(var character, var move):
	#print("deplacerAction")
	character.move(move)
func deplacerRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	#print("deplacerRange")
	var character = characters[currentCharacterIndex]
	if character.m_position.x + character.m_nbStepsBase >= position.x && character.m_position.x - character.m_nbStepsBase <= position.x 	&& character.m_position.y + character.m_nbStepsBase >= position.y && character.m_position.y - character.m_nbStepsBase <= position.y 	&& !toolFunctions["is_something_there"].call_func(characters, position) && !toolFunctions["is_something_there"].call_func(objects, position):
		return true
	return false

func posterizeAction(var character, var enemi):
	#print("posterizeAction")
	enemi.takeDamages(character.m_nbAttack)
	enemi.applyEffect("stunt")
func posterizeRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	#print("posterizeRange")
	var character = characters[currentCharacterIndex]
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.y == position.y) || (character.m_position.y + 1 >= position.y && character.m_position.y - 1 <= position.y && character.m_position.x == position.x)) && toolFunctions["is_enemi_there"].call_func(characters, position):
		return true
	return false

func crossAction(var character, var enemi):
	#print("crossAction")
	enemi.applyEffect("stunt")
func crossRange(var characters, var currentCharacterIndex, var objects, var position, var toolFunctions):
	#print("crossRange")
	var character = characters[currentCharacterIndex]
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.y == position.y) || (character.m_position.y + 1 >= position.y && character.m_position.y - 1 <= position.y && character.m_position.x == position.x)) && toolFunctions["is_enemi_there"].call_func(characters, position):
		return true
	return false