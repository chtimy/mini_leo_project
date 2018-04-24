extends "res://RPGFightFramework/scripts/actions.gd"

func _init().():
	pass

#here write all [name of the action] + [GetInfo] | [Action] | [RangeConditions]

#static func [name of the action]GetInfo(var game):
#	Get all informations you need for the action
#	You can save the information in a buffer in game with the following functions :
	#	saveValue(var value)
	#	loadValue(var index)
	#	hasValue(var index)
#	Don't forget to clear the buffer in the end of the action function below
#	Need to return true if the function get all needed informations

#static func [name of the action]Action(var game):
#	Description action here
#	Clear the buffer if you don't need it anymore

#static func [name of the action]Conditions(var game):
#	Write all the conditions to make your action work
#	Need to return true if the action can be executed

# attentin pour les attaques passives c'est pas bon
# Bien faire la distinction entre ennemi et player


#static func deplacementConditions(var game):
#	return  game.getMap().testMatrixConditionFunction(funcref("res://RPGFightFramework/scripts/perso/actionPerso.gd", "deplacementRangeConditions"), game)
static func deplacementGetInfo(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.saveValue(pos)
		game.getMap().setCursorVisible(false)
		return true
	return false
static func deplacementAction(var game):
	print("deplacerAction")
	game.currentPlayingCharacter().setPosition(game.loadValue(0), game.getMap())
static func deplacementRangeConditions(var game, var activeOverlay = false):
	var map = game.getMap()
	var matrix = map.getMatrix()
	var success = false
	var character = game.currentPlayingCharacter()
	var position
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			for k in range(matrix[i][j].size()):
				position = Vector3(i, j, k)
				if character.m_position.x + character.m_caracteristics.nbMoves >= position.x && character.m_position.x - character.m_caracteristics.nbMoves <= position.x && character.m_position.z + character.m_caracteristics.nbMoves >= position.z && character.m_position.z - character.m_caracteristics.nbMoves <= position.z && map.on_surface(position):
					var selectable = game.getMap().getSelectable(position)
					if !selectable || selectable.isCategory("objects"):
						if activeOverlay:
							map.addOverlay(position)
							success = true
						else:
							return true
	if success && activeOverlay:
		map.moveCursorTo(character.m_position)
		map.setCursorVisible(true)
	return success


#static func attackConditions(var game):
#	var map = game.getMap()
#	return  map.testMatrixConditionFunction(funcref("res://RPGFightFramework/scripts/perso/actionPerso.gd", "deplacementRangeConditions"))
static func attackGetInfo(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.saveValue(pos)
		return true
	return false
static func attackAction(var game):
	print("attackAction")
	var character = game.currentPlayingCharacter()
	var enemi = game.getMap().getSelectable(game.loadValue(0))
	enemi.decreaseCaracteristic("life", character.getCaracteristic("attack"))
	game.clearValues()
static func attackRangeConditions(var game, var activeOverlay = false):
	var character = game.currentPlayingCharacter()
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.z == position.z) || (character.m_position.z + 1 >= position.z && character.m_position.z - 1 <= position.z && character.m_position.z == position.x)) && game.getMap.on_surface(position):
		var selectable = game.getMap().getSelectable(position)
		if selectable && (selectable.isCategory("Players") || selectable.isCategory("Enemis")) && selectable.category() != character.category():
			return true
	return false

#static func posterizeConditions(var game):
#	var map = game.getMap()
#	return  map.testMatrixConditionFunction(funcref("res://RPGFightFramework/scripts/perso/actionPerso.gd", "deplacementRangeConditions"))
static func posterizeGetInfo(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.saveValue(pos)
		return true
	return false
static func posterizeAction(var game):
	print("posterizeAction")
	var character = game.currentPlayingCharacter()
	var enemi = game.getMap().getSelectable(game.loadValue(0))
	enemi.decreaseCaracteristic("life", character.getCaracteristic("attack"))
	if character.throwDiceForCaracteristic("strength"):
		enemi.addCaracteristic("state", {"stunt": 1})
	game.clearValues()
static func posterizeRangeConditions(var game, var activeOverlay = false):
	var character = game.currentPlayingCharacter()
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.z == position.z) || (character.m_position.z + 1 >= position.z && character.m_position.z - 1 <= position.z && character.m_position.z == position.x)) && game.getMap.on_surface(position):
		var selectable = game.getMap().getSelectable(position)
		if selectable && (selectable.isCategory("Players") || selectable.isCategory("Enemis")) && selectable.category() != character.category():
			return true
	return false



#static func crossConditions(var game):
#	var map = game.getMap()
#	return  map.testMatrixConditionFunction(funcref("res://RPGFightFramework/scripts/perso/actionPerso.gd", "deplacementRangeConditions"))
static func crossGetInfo(var game):
	var map = game.getMap()
	if !game.hasValue(0):
		var pos = map.chooseTile()
		if pos:
			game.saveValue(pos)
	else:
		var pos = map.chooseTile()
		if pos:
			game.saveValue(pos)
			return true
	return false
#fonction pour executer l'action
static func crossAction(var game):
	print("crossAction")
	var map = game.getMap()
	var character = game.currentPlayingCharacter()
	var enemiPosition = game.loadValue(0)
	var enemi = map.getSelectable(enemiPosition)
	var characterPosition = game.loadValue(1)
	#cross
	character.setPosition(characterPosition, map)
	enemi.setCharacteristic("orientation", enemiPosition - characterPosition)
	#si block
	var selectable = map.getSelectable(enemiPosition + enemi.getCaracteristic("orientation"))
	#a ameliorer
	if (selectable.isCategory("Player") and character.isCategory("Enemis")) or (character.isCategory("Player") and enemi.isCategory("Enemis")):
		var state = selectable.getCaracteristic("state")
		if state.has("block") and state.block > 0:
			if !enemi.throwDiceForCaracteristics("perception"):
				enemi.decreaseCaracteristic("life", enemi.getCaracteristic("attack"))
		else:
			selectable.decreaseCaracteristic("life", enemi.getCaracteristic("attack"))
	game.clearValues()
#fonction qui établit la range possible en fonction des caractéristiques également
static func crossRangeConditions(var game, var activeOverlay = false):
	var character = game.currentPlayingCharacter()
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.z == position.z) || (character.m_position.z + 1 >= position.z && character.m_position.z - 1 <= position.z && character.m_position.x == position.x)) && game.getMap.on_surface(position):
		var selectable = game.getMap().getSelectable(position)
		if selectable && (selectable.isCategory("Players") || selectable.isCategory("Enemis")) && selectable.category() != character.category():
			if selectable.getCaracteristic("orientation") == -character.getCaracteristic("orientation"):
				return true
	return false

#static func stealConditions(var game):
#	var map = game.getMap()
#	return  map.testMatrixConditionFunction(funcref("res://RPGFightFramework/scripts/perso/actionPerso.gd", "deplacementRangeConditions"))
static func stealGetInfo(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.saveValue(pos)
		return true
	return false
static func stealAction(var game):
	print("stealAction")
#	character.steal(enemi)
static func stealRangeConditions(var game, var activeOverlay = false):
	var character = game.currentPlayingCharacter()
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.z == position.z) || (character.m_position.z + 1 >= position.z && character.m_position.z - 1 <= position.z && character.m_position.x == position.x)) && game.getMap.on_surface(position):
		var selectable = game.getMap().getSelectable(position)
		if selectable && (selectable.isCategory("Players") || selectable.isCategory("Enemis")) && selectable.category() != character.category():
			return true
	return false

#static func blockConditions(var game):
#	return true
static func blockGetInfo(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.saveValue(pos)
		return true
	return false
static func blockAction(var game):
	print("blockAction")
	var character = game.currentPlayingCharacter()
	character.addCaracteristic("state", {"block": 1})
static func blockRangeConditions(var game, var activeOverlay = false):
	return true


#static func from_downtownConditions(var game):
#	var map = game.getMap()
#	return  map.testMatrixConditionFunction(funcref("res://RPGFightFramework/scripts/perso/actionPerso.gd", "deplacementRangeConditions"))	
static func from_downtownGetInfo(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.saveValue(pos)
		return true
	return false
static func from_downtownAction(var game):
	print("from downtown Action")
static func from_downtownRangeConditions(var game, var activeOverlay = false):
	var character = game.currentPlayingCharacter()
	if character.m_position.x + character.m_caracteristics.nbMoves >= position.x && character.m_position.x - character.m_caracteristics.nbMoves <= position.x && character.m_position.z + character.m_caracteristics.nbMoves >= position.z && character.m_position.z - character.m_caracteristics.nbMoves <= position.z && game.getMap.on_surface(position):
		var selectable = game.getMap().getSelectable(position)
		if selectable && (selectable.isCategory("Players") || selectable.isCategory("Enemis")) && selectable.category() != character.category():
			return true
	return false



#static func up_and_downConditions(var game):
#	var map = game.getMap()
#	return  map.testMatrixConditionFunction(funcref("res://RPGFightFramework/scripts/perso/actionPerso.gd", "deplacementRangeConditions"))
static func up_and_downGetInfo(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.saveValue(pos)
		return true
	return false
static func up_and_downAction(var game):
	print("up and down Action")
	var map = game.getMap()
	var character = game.currentPlayingCharacter()
	var enemiPosition = game.loadValue(0)
	var enemi = map.getSelectable(enemiPosition)
	var characterPosition = game.loadValue(1)
	#cross
	character.setPosition(characterPosition, map)
	enemi.setCharacteristic("orientation", enemiPosition - characterPosition)
static func up_and_downRangeConditions(var game, var activeOverlay = false):
	var character = game.currentPlayingCharacter()
	if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.z == position.z) || (character.m_position.z + 1 >= position.z && character.m_position.z - 1 <= position.z && character.m_position.x == position.x)) && game.getMap.on_surface(position):
		var selectable = game.getMap().getSelectable(position)
		if selectable && (selectable.isCategory("Players") || selectable.isCategory("Enemis")) && selectable.category() != character.category():
			return true
	return false
	


#static func passeConditions(var game):
#	var map = game.getMap()
#	return  map.testMatrixConditionFunction(funcref("res://RPGFightFramework/scripts/perso/actionPerso.gd", "deplacementRangeConditions"))
static func passeGetInfo(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.saveValue(pos)
		return true
	return false
static func passeAction(var game, var receiver_character):
	print("passe Action")
#	character.pass(receiver_character)
static func passeRangeConditions(var game, var activeOverlay = false):
	var character = currentPlayingCharacter()
	if character.m_position.x + character.m_caracteristics.nbMoves >= position.x && character.m_position.x - character.m_caracteristics.nbMoves <= position.x && character.m_position.z + character.m_caracteristics.nbMoves >= position.z && character.m_position.z - character.m_caracteristics.nbMoves <= position.z && game.getMap.on_surface(position):
		var selectable = game.getMap().getSelectable(position)
		if selectable && (selectable.category() == character.category()):
			return true
	return false