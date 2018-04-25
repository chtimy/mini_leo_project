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


static func deplacementGetInfo(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.saveValue("finalPos", pos)
		return true
	return false
static func deplacementAction(var game):
	print("deplacerAction")
	var map = game.getMap()
	map.disableAllOverlayCases()
	game.getMap().setCursorVisible(false)
	var position = game.loadValue("finalPos")
	map.moveSelectable(game.currentPlayingCharacter().m_position, position)
	game.currentPlayingCharacter().setPosition(position, map)
	game.clearValues()
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
					var selectable = map.getSelectable(position)
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


static func attackGetInfo(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.saveValue("pos", pos)
		return true
	return false
static func attackAction(var game):
	print("attackAction")
	var map = game.getMap()
	var character = game.currentPlayingCharacter()
	var enemi = map.getSelectable(game.loadValue("pos"))
	enemi.decreaseCaracteristic("life", character.getCaracteristic("attack"))
	character.setRotationToTarget(enemi.m_position)
	game.clearValues()
	map.disableAllOverlayCases()
	map.setCursorVisible(false)
static func attackRangeConditions(var game, var activeOverlay = false):
	var map = game.getMap()
	var matrix = map.getMatrix()
	var success = false
	var character = game.currentPlayingCharacter()
	var position
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			for k in range(matrix[i][j].size()):
				position = Vector3(i, j, k)
				if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.z == position.z) || (character.m_position.z + 1 >= position.z && character.m_position.z - 1 <= position.z && character.m_position.z == position.x)) && map.on_surface(position):
					var selectable = game.getMap().getSelectable(position)
					if selectable && (selectable.isCategory("Players") || selectable.isCategory("Enemis")) && selectable.category() != character.category():
						if activeOverlay:
							map.addOverlay(position)
							success = true
						else:
							return true
	if success && activeOverlay:
		map.moveCursorTo(character.m_position)
		map.setCursorVisible(true)
	return success


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
	character.setRotationToTarget(enemi.m_position)
	game.clearValues()
	game.getMap().disableAllOverlayCases()
static func posterizeRangeConditions(var game, var activeOverlay = false):
	var map = game.getMap()
	var matrix = map.getMatrix()
	var success = false
	var character = game.currentPlayingCharacter()
	var position
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			for k in range(matrix[i][j].size()):
				position = Vector3(i, j, k)
				if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.z == position.z) || (character.m_position.z + 1 >= position.z && character.m_position.z - 1 <= position.z && character.m_position.z == position.x)) && game.getMap.on_surface(position):
					var selectable = game.getMap().getSelectable(position)
					if selectable && (selectable.isCategory("Players") || selectable.isCategory("Enemis")) && selectable.category() != character.category():
						if activeOverlay:
							map.addOverlay(position)
							success = true
						else:
							return true
	if success && activeOverlay:
		map.moveCursorTo(character.m_position)
		map.setCursorVisible(true)
	return success



static func crossGetInfo(var game):
	var map = game.getMap()
	var tour = game.getValue("tour")
	if !tour.treated:
		tour.treated = true
		var pos = game.getValue("posEnemi")
		var casesTo = []
		var characterPosition = game.currentPlayingCharacter().m_position
		var enemi = map.getSelectable(pos)
		var orientation = enemi.getCaracteristic("orientation")
		orientation = Vector3(abs(orientation.x) - 1, 0, abs(orientation.z) - 1)
		casesTo.push_back(characterPosition + orientation)
		casesTo.push_back(characterPosition - orientation)
		casesTo.push_back(enemi.m_position + orientation)
		casesTo.push_back(enemi.m_position - orientation)
		for caseTo in casesTo:
			var selectable = map.getSelectable(caseTo)
			if !selectable || !selectable.isCategory("Players") && !selectable.isCategory("Enemis"):
				map.addOverlay(caseTo)
	var pos = map.chooseTile()
	if pos:
		if tour.number < 2:
			game.saveValue("posEnemi", pos)
			game.saveValue("tour", {"treated" : false, "number" : tour.number+1})
			map.disableAllOverlayCases()
		else:
			game.saveValue("posTo", pos)
			game.getMap().setCursorVisible(false)
			map.disableAllOverlayCases()
			return true
	return false
#fonction pour executer l'action
static func crossAction(var game):
	print("crossAction")
	var map = game.getMap()
	var character = game.currentPlayingCharacter()
	var enemiPosition = game.loadValue("posEnemi")
	var enemi = map.getSelectable(enemiPosition)
	var characterPosition = game.loadValue("posTo")
	#cross
	character.setPosition(characterPosition, map)
	enemi.setCaracteristic("orientation", enemiPosition - characterPosition)
	#si block
	var selectable = map.getSelectable(enemiPosition + enemi.getCaracteristic("orientation"))
	#a ameliorer
	if (selectable.isCategory("Players") && character.isCategory("Enemis")) || (character.isCategory("Players") && enemi.isCategory("Enemis")):
		var state = selectable.getCaracteristic("state")
		if state.has("block") && state.block > 0:
			if !enemi.throwDiceForCaracteristics("perception"):
				enemi.decreaseCaracteristic("life", enemi.getCaracteristic("attack"))
		else:
			selectable.decreaseCaracteristic("life", enemi.getCaracteristic("attack"))
	character.setRotationToTarget(enemiPosition)
	game.clearValues()
	game.getMap().disableAllOverlayCases()
#fonction qui établit la range possible en fonction des caractéristiques également
static func crossRangeConditions(var game, var activeOverlay = false):
	var map = game.getMap()
	var matrix = map.getMatrix()
	var success = false
	var character = game.currentPlayingCharacter()
	var position
	var listPositions = []
	var listPositions2 = []
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			for k in range(matrix[i][j].size()):
				position = Vector3(i, j, k)
				if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.z == position.z) || (character.m_position.z + 1 >= position.z && character.m_position.z - 1 <= position.z && character.m_position.x == position.x)) && map.on_surface(position):
					var selectable = map.getSelectable(position)
					if selectable && (selectable.isCategory("Players") || selectable.isCategory("Enemis")) && selectable.category() != character.category():
						if selectable.getCaracteristic("orientation") == character.m_position - selectable.m_position:
							if !success:
								#espace autour du joueur
								var casesTo = []
								var characterPosition = character.m_position
								var enemiPosition = selectable.m_position
								var orientation = selectable.getCaracteristic("orientation")
								orientation = Vector3(abs(orientation.x) - 1, 0, abs(orientation.z) - 1)
								casesTo.push_back(map.getSelectable(characterPosition + orientation))
								casesTo.push_back(map.getSelectable(characterPosition - orientation))
								casesTo.push_back(map.getSelectable(enemiPosition + orientation))
								casesTo.push_back(map.getSelectable(enemiPosition - orientation))
								for caseTo in casesTo:
									if !caseTo || !caseTo.isCategory("Players") && !caseTo.isCategory("Enemis"):
										success = true
							if activeOverlay:
								listPositions.append(position)
							elif success:
									return true
	if success && activeOverlay:
		map.moveCursorTo(character.m_position)
		map.setCursorVisible(true)
		for pos in listPositions:
			map.addOverlay(pos)
		game.saveValue("tour", {"treated" : true, "number" : 1})
	return success

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
	game.clearValues()
	game.getMap().disableAllOverlayCases()
static func stealRangeConditions(var game, var activeOverlay = false):
	var map = game.getMap()
	var matrix = map.getMatrix()
	var success = false
	var character = game.currentPlayingCharacter()
	var position
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			for k in range(matrix[i][j].size()):
				position = Vector3(i, j, k)
				if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.z == position.z) || (character.m_position.z + 1 >= position.z && character.m_position.z - 1 <= position.z && character.m_position.x == position.x)) && map.on_surface(position):
					var selectable = game.getMap().getSelectable(position)
					if selectable && (selectable.isCategory("Players") || selectable.isCategory("Enemis")) && selectable.category() != character.category():
						if activeOverlay:
							map.addOverlay(position)
							success = true
						else:
							return true
	if success && activeOverlay:
		map.moveCursorTo(character.m_position)
		map.setCursorVisible(true)
	return success

#static func blockConditions(var game):
#	return true
static func blockGetInfo(var game):
	return true
static func blockAction(var game):
	print("blockAction")
	var character = game.currentPlayingCharacter()
	character.addCaracteristic("state", {"block": 1})
	game.clearValues()
	game.getMap().disableAllOverlayCases()
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
	game.clearValues()
	game.getMap().disableAllOverlayCases()
static func from_downtownRangeConditions(var game, var activeOverlay = false):
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
					if selectable && (selectable.isCategory("Players") || selectable.isCategory("Enemis")) && selectable.category() != character.category():
						if activeOverlay:
							map.addOverlay(position)
							success = true
						else:
							return true
	if success && activeOverlay:
		map.moveCursorTo(character.m_position)
		map.setCursorVisible(true)
	return success



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
	game.clearValues()
	game.getMap().disableAllOverlayCases()
static func up_and_downRangeConditions(var game, var activeOverlay = false):
	var map = game.getMap()
	var matrix = map.getMatrix()
	var success = false
	var character = game.currentPlayingCharacter()
	var position
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			for k in range(matrix[i][j].size()):
				position = Vector3(i, j, k)
				if ((character.m_position.x + 1 >= position.x && character.m_position.x - 1 <= position.x && character.m_position.z == position.z) || (character.m_position.z + 1 >= position.z && character.m_position.z - 1 <= position.z && character.m_position.x == position.x)) && map.on_surface(position):
					var selectable = game.getMap().getSelectable(position)
					if selectable && (selectable.isCategory("Players") || selectable.isCategory("Enemis")) && selectable.category() != character.category():
						if activeOverlay:
							map.addOverlay(position)
							success = true
						else:
							return true
	if success && activeOverlay:
		map.moveCursorTo(character.m_position)
		map.setCursorVisible(true)
	return success
	


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
	game.clearValues()
	game.getMap().disableAllOverlayCases()
static func passeRangeConditions(var game, var activeOverlay = false):
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
					if selectable && (selectable.category() == character.category()):
						if activeOverlay:
							map.addOverlay(position)
							success = true
						else:
							return true
	if success && activeOverlay:
		map.moveCursorTo(character.m_position)
		map.setCursorVisible(true)
	return success
	
static func passerGetInfo(var game):
	return true
static func passerAction(var game):
	pass
static func passerRangeConditions(var game, var activeOverlay = false):
	return true