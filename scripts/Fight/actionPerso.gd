extends "res://scripts/Fight/actions.gd"

func _init().():
	pass

#here write all [name of the action] + [Action] | [_range_conditions]

#static func [name of the action]_get_info(var game):
#	Get all informations you need for the action
#	You can save the information in a buffer in game with the following functions :
	#	save_value(var value)
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

# attention pour les attaques passives c'est pas bon
# Bien faire la distinction entre ennemi et player


static func deplacement_action(var game):
	game.set_process(false)
	var pos = yield(game.map, "overlay_clicked_from_map")
	var map = game.get_map()
	map.move_selectable_to(game.current_playing_character().position, pos)
	game.current_playing_character().set_position_in_matrix(pos, map)
	map.disable_selection()
	game.end_turn()
static func deplacement_range_conditions(var game, var activeOverlay = false):
	var map = game.map
	var matrix = map.matrix
	var success = false
	var character = game.current_playing_character()
	var from_position = character.position
	var to_position
	var relative_position
	var zona = range(-character.m_caracteristics.nbMoves, character.m_caracteristics.nbMoves)
	for i in zona:
		for j in zona:
			relative_position = Vector3(i, 0, j)
			to_position = from_position + relative_position
			relative_position = relative_position.abs()
			if relative_position.x + relative_position.z <= character.m_caracteristics.nbMoves && map.is_inside_matrix_bounds(to_position):
				var selectable = map.get_selectable_from_matrix(to_position)
				if !selectable || selectable.is_in_group("objects"):
					if activeOverlay:
						map.add_overlay_cell_by_index(to_position)
						success = true
					else:
						return true
	return success


static func attack_get_info(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.save_value("pos", pos)
		return true
	return false
static func attackAction(var game):
	print("attackAction")
	var map = game.getMap()
	var character = game.current_playing_character()
	var enemi = map.get_selectable_from_matrix(game.loadValue("pos"))
	enemi.decreaseCaracteristic("life", character.get_caracteristic("attack"))
	character.setRotationToTarget(enemi.m_position)
	game.clear_values()
	map.disable_all_overlay_cases()
	map.setCursorVisible(false)
static func attack_range_conditions(var game, var activeOverlay = false):
	var map = game.get_map()
	var matrix = map.matrix
	var success = false
	var character = game.current_playing_character()
	var position
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			for k in range(matrix[i][j].size()):
				position = Vector3(i, j, k)
				if ((character.position.x + 1 >= position.x && character.position.x - 1 <= position.x && character.position.z == position.z) || (character.position.z + 1 >= position.z && character.position.z - 1 <= position.z && character.position.z == position.x)) && map.on_surface(position):
					var selectable = game.get_map().get_selectable_from_matrix(position)
					if selectable && (selectable.is_in_group("Players") || selectable.is_in_group("Enemis")) && selectable.get_groups() != character.get_groups():
						if activeOverlay:
							map.add_overlay(position)
							success = true
						else:
							return true
	if success && activeOverlay:
		map.moveCursorTo(character.position)
		map.setCursorVisible(true)
	return success


static func posterize_get_info(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.save_value(pos)
		return true
	return false
static func posterizeAction(var game):
	print("posterizeAction")
	var character = game.current_playing_character()
	var enemi = game.getMap().get_selectable_from_matrix(game.loadValue(0))
	enemi.decreaseCaracteristic("life", character.get_caracteristic("attack"))
	if character.throwDiceForCaracteristic("strength"):
		enemi.add_caracteristic("state", {"stunt": 1})
	character.setRotationToTarget(enemi.m_position)
	game.clear_values()
	game.getMap().disable_all_overlay_cases()
static func posterize_range_conditions(var game, var activeOverlay = false):
	var map = game.getMap()
	var matrix = map.getMatrix()
	var success = false
	var character = game.current_playing_character()
	var position
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			for k in range(matrix[i][j].size()):
				position = Vector3(i, j, k)
				if ((character.position.x + 1 >= position.x && character.position.x - 1 <= position.x && character.position.z == position.z) || (character.position.z + 1 >= position.z && character.position.z - 1 <= position.z && character.position.z == position.x)) && game.getMap.on_surface(position):
					var selectable = game.getMap().get_selectable_from_matrix(position)
					if selectable && (selectable.is_in_group("Players") || selectable.is_in_group("Enemis")) && selectable.get_groups() != character.get_groups():
						if activeOverlay:
							map.add_overlay(position)
							success = true
						else:
							return true
	if success && activeOverlay:
		map.moveCursorTo(character.position)
		map.setCursorVisible(true)
	return success



static func cross_get_info(var game):
	var map = game.getMap()
	var tour = game.getValue("tour")
	if !tour.treated:
		tour.treated = true
		var pos = game.getValue("posEnemi")
		var casesTo = []
		var characterPosition = game.current_playing_character().m_position
		var enemi = map.get_selectable_from_matrix(pos)
		var orientation = enemi.get_caracteristic("orientation")
		orientation = Vector3(abs(orientation.x) - 1, 0, abs(orientation.z) - 1)
		casesTo.push_back(characterPosition + orientation)
		casesTo.push_back(characterPosition - orientation)
		casesTo.push_back(enemi.m_position + orientation)
		casesTo.push_back(enemi.m_position - orientation)
		for caseTo in casesTo:
			var selectable = map.get_selectable_from_matrix(caseTo)
			if !selectable || !selectable.is_in_group("Players") && !selectable.is_in_group("Enemis"):
				map.add_overlay(caseTo)
	var pos = map.chooseTile()
	if pos:
		if tour.number < 2:
			game.save_value("posEnemi", pos)
			game.save_value("tour", {"treated" : false, "number" : tour.number+1})
			map.disable_all_overlay_cases()
		else:
			game.save_value("posTo", pos)
			game.getMap().setCursorVisible(false)
			map.disable_all_overlay_cases()
			return true
	return false
#fonction pour executer l'action
static func crossAction(var game):
	print("crossAction")
	var map = game.getMap()
	var character = game.current_playing_character()
	var enemiPosition = game.loadValue("posEnemi")
	var enemi = map.get_selectable_from_matrix(enemiPosition)
	var characterPosition = game.loadValue("posTo")
	#cross
	character.setPosition(characterPosition, map)
	enemi.setCaracteristic("orientation", enemiPosition - characterPosition)
	#si block
	var selectable = map.get_selectable_from_matrix(enemiPosition + enemi.get_caracteristic("orientation"))
	#a ameliorer
	if (selectable.is_in_group("Players") && character.is_in_group("Enemis")) || (character.is_in_group("Players") && enemi.is_in_group("Enemis")):
		var state = selectable.get_caracteristic("state")
		if state.has("block") && state.block > 0:
			if !enemi.throwDiceForCaracteristics("perception"):
				enemi.decreaseCaracteristic("life", enemi.get_caracteristic("attack"))
		else:
			selectable.decreaseCaracteristic("life", enemi.get_caracteristic("attack"))
	character.setRotationToTarget(enemiPosition)
	game.clear_values()
	game.getMap().disable_all_overlay_cases()
#fonction qui établit la range possible en fonction des caractéristiques également
static func cross_range_conditions(var game, var activeOverlay = false):
	var map = game.get_map()
	var matrix = map.matrix
	var success = false
	var character = game.current_playing_character()
	var position
	var listPositions = []
	var listPositions2 = []
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			for k in range(matrix[i][j].size()):
				position = Vector3(i, j, k)
				if ((character.position.x + 1 >= position.x && character.position.x - 1 <= position.x && character.position.z == position.z) || (character.position.z + 1 >= position.z && character.position.z - 1 <= position.z && character.position.x == position.x)) && map.on_surface(position):
					var selectable = map.get_selectable_from_matrix(position)
					if selectable && (selectable.is_in_group("Players") || selectable.is_in_group("Enemis")) && selectable.get_groups() != character.get_groups():
						if selectable.get_caracteristic("orientation") == character.position - selectable.m_position:
							if !success:
								#espace autour du joueur
								var casesTo = []
								var characterPosition = character.position
								var enemiPosition = selectable.m_position
								var orientation = selectable.get_caracteristic("orientation")
								orientation = Vector3(abs(orientation.x) - 1, 0, abs(orientation.z) - 1)
								casesTo.push_back(map.get_selectable_from_matrix(characterPosition + orientation))
								casesTo.push_back(map.get_selectable_from_matrix(characterPosition - orientation))
								casesTo.push_back(map.get_selectable_from_matrix(enemiPosition + orientation))
								casesTo.push_back(map.get_selectable_from_matrix(enemiPosition - orientation))
								for caseTo in casesTo:
									if !caseTo || !caseTo.is_in_group("Players") && !caseTo.is_in_group("Enemis"):
										success = true
							if activeOverlay:
								listPositions.append(position)
							elif success:
									return true
	if success && activeOverlay:
#		map.moveCursorTo(character.position)
#		map.setCursorVisible(true)
		for pos in listPositions:
			map.add_overlay(pos)
		game.save_value("tour", {"treated" : true, "number" : 1})
	return success

#static func stealConditions(var game):
#	var map = game.getMap()
#	return  map.testMatrixConditionFunction(funcref("res://RPGFightFramework/scripts/perso/actionPerso.gd", "deplacement_range_conditions"))
static func steal_get_info(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.save_value(pos)
		return true
	return false
static func steal_action(var game):
	print("steal_action")
#	character.steal(enemi)
	game.clear_values()
	game.get_map().disable_all_overlay_cases()
static func steal_range_conditions(var game, var activeOverlay = false):
	var map = game.get_map()
	var matrix = map.matrix
	var success = false
	var character = game.current_playing_character()
	var position
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			for k in range(matrix[i][j].size()):
				position = Vector3(i, j, k)
				if ((character.position.x + 1 >= position.x && character.position.x - 1 <= position.x && character.position.z == position.z) || (character.position.z + 1 >= position.z && character.position.z - 1 <= position.z && character.position.x == position.x)) && map.on_surface(position):
					var selectable = game.map.get_selectable_from_matrix(position)
					if selectable && (selectable.is_in_group("Players") || selectable.is_in_group("Enemis")) && selectable.get_groups() != character.get_groups():
						if activeOverlay:
							map.add_overlay(position)
							success = true
						else:
							return true
	if success && activeOverlay:
		map.moveCursorTo(character.position)
		map.setCursorVisible(true)
	return success

#static func blockConditions(var game):
#	return true
static func block_get_info(var game):
	return true
static func block_action(var game):
	print("blockAction")
	var character = game.current_playing_character()
	character.add_caracteristic("state", {"block": 1})
	game.clear_values()
	game.getMap().disable_all_overlay_cases()
static func block_range_conditions(var game, var activeOverlay = false):
	return true


#static func from_downtownConditions(var game):
#	var map = game.getMap()
#	return  map.testMatrixConditionFunction(funcref("res://RPGFightFramework/scripts/perso/actionPerso.gd", "deplacement_range_conditions"))	
static func from_downtown_get_info(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.save_value(pos)
		return true
	return false
static func from_downtown_action(var game):
	print("from downtown Action")
	game.clear_values()
	game.getMap().disable_all_overlay_cases()
static func from_downtown_range_conditions(var game, var activeOverlay = false):
	var map = game.getMap()
	var matrix = map.getMatrix()
	var success = false
	var character = game.current_playing_character()
	var position
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			for k in range(matrix[i][j].size()):
				position = Vector3(i, j, k)
				if character.position.x + character.m_caracteristics.nbMoves >= position.x && character.position.x - character.m_caracteristics.nbMoves <= position.x && character.position.z + character.m_caracteristics.nbMoves >= position.z && character.position.z - character.m_caracteristics.nbMoves <= position.z && map.on_surface(position):
					var selectable = game.getMap().get_selectable_from_matrix(position)
					if selectable && (selectable.is_in_group("Players") || selectable.is_in_group("Enemis")) && selectable.get_groups() != character.get_groups():
						if activeOverlay:
							map.add_overlay(position)
							success = true
						else:
							return true
#	if success && activeOverlay:
#		map.moveCursorTo(character.position)
#		map.setCursorVisible(true)
	return success



#static func up_and_downConditions(var game):
#	var map = game.getMap()
#	return  map.testMatrixConditionFunction(funcref("res://RPGFightFramework/scripts/perso/actionPerso.gd", "deplacement_range_conditions"))
static func up_and_down_get_info(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.save_value(pos)
		return true
	return false
static func up_and_downAction(var game):
	print("up and down Action")
	var map = game.getMap()
	var character = game.current_playing_character()
	var enemiPosition = game.loadValue(0)
	var enemi = map.get_selectable_from_matrix(enemiPosition)
	var characterPosition = game.loadValue(1)
	#cross
	character.setPosition(characterPosition, map)
	enemi.setCharacteristic("orientation", enemiPosition - characterPosition)
	game.clear_values()
	game.getMap().disable_all_overlay_cases()
static func up_and_down_range_conditions(var game, var activeOverlay = false):
	var map = game.getMap()
	var matrix = map.getMatrix()
	var success = false
	var character = game.current_playing_character()
	var position
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			for k in range(matrix[i][j].size()):
				position = Vector3(i, j, k)
				if ((character.position.x + 1 >= position.x && character.position.x - 1 <= position.x && character.position.z == position.z) || (character.position.z + 1 >= position.z && character.position.z - 1 <= position.z && character.position.x == position.x)) && map.on_surface(position):
					var selectable = game.getMap().get_selectable_from_matrix(position)
					if selectable && (selectable.is_in_group("Players") || selectable.is_in_group("Enemis")) && selectable.get_groups() != character.get_groups():
						if activeOverlay:
							map.add_overlay(position)
							success = true
						else:
							return true
	if success && activeOverlay:
		map.moveCursorTo(character.position)
		map.setCursorVisible(true)
	return success
	

#static func passeConditions(var game):
#	var map = game.getMap()
#	return  map.testMatrixConditionFunction(funcref("res://RPGFightFramework/scripts/perso/actionPerso.gd", "deplacement_range_conditions"))
static func passe_get_info(var game):
	var map = game.getMap()
	var pos = map.chooseTile()
	if pos:
		game.save_value(pos)
		return true
	return false
static func passeAction(var game, var receiver_character):
	print("passe Action")
#	character.pass(receiver_character)
	game.clear_values()
	game.getMap().disable_all_overlay_cases()
static func passe_range_conditions(var game, var activeOverlay = false):
	var map = game.map
	var matrix = map.matrix
	var success = false
	var character = game.current_playing_character()
	var position
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			for k in range(matrix[i][j].size()):
				position = Vector3(i, j, k)
				if character.position.x + character.m_caracteristics.nbMoves >= position.x && character.position.x - character.m_caracteristics.nbMoves <= position.x && character.position.z + character.m_caracteristics.nbMoves >= position.z && character.position.z - character.m_caracteristics.nbMoves <= position.z && map.on_surface(position):
					var selectable = game.map.get_selectable_from_matrix(position)
					if selectable && (selectable.get_groups() == character.get_groups()):
						if activeOverlay:
							map.add_overlay(position)
							success = true
						else:
							return true
	if success && activeOverlay:
		map.moveCursorTo(character.position)
		map.setCursorVisible(true)
	return success
	
static func passer_get_info(var game):
	return true
static func passerAction(var game):
	pass
static func passer_range_conditions(var game, var activeOverlay = false):
	return true