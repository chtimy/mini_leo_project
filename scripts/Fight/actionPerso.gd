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
	var path = null
	if game.current_playing_character().is_in_group("Enemis"):
		path = map.shortest_path(game.current_playing_character().position, pos, ["Players"])
	else:
		path = map.shortest_path(game.current_playing_character().position, pos, ["Enemis"])
	print(path)
	map.move_selectable_to(game.current_playing_character().position, pos)
	game.current_playing_character().set_position_in_matrix(pos, map)
	map.disable_selection()
	game.end_turn()
static func deplacement_range_conditions(var game, var activeOverlay = false):
	var map = game.map
	var success = false
	var character = game.current_playing_character()
	var from_position = character.position
	var to_position
	var relative_position
	var zona = range(-character.caracteristics.nbMoves, character.caracteristics.nbMoves+1)
	for i in zona:
		for j in zona:
			relative_position = Vector3(i, 0, j)
			to_position = from_position + relative_position
			relative_position = relative_position.abs()
			if relative_position.x + relative_position.z <= character.caracteristics.nbMoves && map.is_inside_matrix_bounds(to_position):
				var selectable = map.get_selectable_from_matrix(to_position)
				if !selectable || selectable.is_in_group("objects"):
					if activeOverlay:
						map.add_overlay_cell_by_index(to_position)
						success = true
					else:
						return true
	return success


static func attack_action(var game):
	game.set_process(false)
	var map = game.map
	var pos = yield(map, "overlay_clicked_from_map")
	print("attackAction")
	var character = game.current_playing_character()
	var enemi = map.get_selectable_from_matrix(pos)
	enemi.decrease_caracteristic("life", character.get_caracteristic("attack"))
	character.set_rotation_to_target(enemi.position)
	map.disable_selection()
	game.end_turn()
static func attack_range_conditions(var game, var activeOverlay = false):
	var map = game.map
	var success = false
	var character = game.current_playing_character()
	var from_position = character.position
	var to_position
	var relative_position
	var zona = range(-1, 2)
	for i in zona:
		for j in zona:
			relative_position = Vector3(i, 0, j)
			to_position = from_position + relative_position
			relative_position = relative_position.abs()
			if relative_position.x + relative_position.z <= 1 && map.is_inside_matrix_bounds(to_position):
				var selectable = map.get_selectable_from_matrix(to_position)
				if selectable && (selectable.is_in_group("Players") || selectable.is_in_group("Enemis")) && selectable.get_groups() != character.get_groups():
					if activeOverlay:
						map.add_overlay_cell_by_index(to_position)
						success = true
					else:
						return true
	return success


static func posterize_action(var game):
	print("posterizeAction")
	game.set_process(false)
	var map = game.map
	var pos = yield(map, "overlay_clicked_from_map")
	var character = game.current_playing_character()
	var enemi = map.get_selectable_from_matrix(pos)

	character.set_rotation_to_target(enemi.position)
	enemi.set_position_in_matrix(character.front(2), map)
	character.set_position_in_matrix(character.front(), map)
	enemi.decrease_caracteristic("life", character.get_caracteristic("attack"))
	if character.throw_dice_for_caracteristic("strength"):
		enemi.add_caracteristic("state", {"stunt": 1})
	game.clear_values()
	map.disable_selection()
	game.end_turn()
static func posterize_range_conditions(var game, var activeOverlay = false):
	var map = game.map
	var success = false
	var character = game.current_playing_character()
	var from_position = character.position
	var to_position
	var relative_position
	var zona = range(-1, 2)
	for i in zona:
		for j in zona:
			relative_position = Vector3(i, 0, j)
			to_position = from_position + relative_position
			relative_position = relative_position.abs()
			if relative_position.x + relative_position.z <= 1 && map.is_inside_matrix_bounds(to_position):
				var selectable = map.get_selectable_from_matrix(to_position)
				if selectable && (selectable.is_in_group("Players") || selectable.is_in_group("Enemis")) && selectable.get_groups() != character.get_groups():
					if activeOverlay:
						map.add_overlay_cell_by_index(to_position)
						success = true
					else:
						return true
	return success

static func cross_action(var game):
	print("crossAction")
	var enemi_position
	var character_position_to
	var character = game.current_playing_character()
	var enemi
	var map = game.map
	var tour = game.get_value("tour")
	
	while tour.number < 3:
		if !tour.treated:
			tour.treated = true
			var pos = enemi_position
			var cases_to = []
			enemi = map.get_selectable_from_matrix(pos)
			cases_to.push_back(character.right())
			cases_to.push_back(character.left())
			cases_to.push_back(enemi.right())
			cases_to.push_back(enemi.left())
			for case_to in cases_to:
				var selectable = map.get_selectable_from_matrix(case_to)
				if !selectable || !selectable.is_in_group("Players") && !selectable.is_in_group("Enemis"):
					map.add_overlay_cell_by_index(case_to)
		game.set_process(false)
		var pos = yield(map, "overlay_clicked_from_map")
		if tour.number < 2:
			enemi_position = pos
			character.set_rotation_to_target(enemi_position)
			tour.treated = false
		else:
			character_position_to = pos
		map.remove_all_overlay_cells()
		tour.number += 1
		

	#cross
	character.set_position_in_matrix(character_position_to, map)
	if (enemi.right() - enemi.position).dot(character.position - enemi.position) > 0:
		enemi.set_caracteristic("orientation", enemi.left() - enemi.position)
		enemi.set_rotation_to_target(enemi.right())
	else:
		enemi.set_caracteristic("orientation", enemi.right() - enemi.position)
		enemi.set_rotation_to_target(enemi.left())
	#si block
	var selectable = map.get_selectable_from_matrix(enemi.front())
	print(selectable)
	#a ameliorer
	if (selectable && selectable.is_in_group("Players") && character.is_in_group("Enemis")) || (character.is_in_group("Players") && enemi.is_in_group("Enemis")):
		var state = selectable.get_caracteristic("state")
		if state.has("block") && state.block > 0:
			if !enemi.throw_dice_for_caracteristics("perception"):
				enemi.decrease_caracteristic("life", enemi.get_caracteristic("attack"))
		else:
			selectable.decrease_caracteristic("life", enemi.get_caracteristic("attack"))
	game.clear_values()
	map.disable_selection()
#fonction qui établit la range possible en fonction des caractéristiques également
static func cross_range_conditions(var game, var activeOverlay = false):
	var map = game.map
	var success = false
	var character = game.current_playing_character()
	var from_position = character.position
	var to_position
	var relative_position
	var list_positions = []
	var list_positions2 = []
	var zona = range(-1, 2)
	for i in zona:
		for j in zona:
			relative_position = Vector3(i, 0, j)
			to_position = from_position + relative_position
			relative_position = relative_position.abs()
			if relative_position.x + relative_position.z <= 1 && map.is_inside_matrix_bounds(to_position):
				var selectable = map.get_selectable_from_matrix(to_position)
				if selectable && (selectable.is_in_group("Players") || selectable.is_in_group("Enemis")) && selectable.get_groups() != character.get_groups():
					if selectable.get_caracteristic("orientation") == character.position - selectable.position:
						if !success:
							#espace autour du joueur
							var cases_to = []
							cases_to.push_back(map.get_selectable_from_matrix(character.front()))
							cases_to.push_back(map.get_selectable_from_matrix(character.behind()))
							cases_to.push_back(map.get_selectable_from_matrix(selectable.front()))
							cases_to.push_back(map.get_selectable_from_matrix(selectable.behind()))
							for case_to in cases_to:
								if !case_to || !case_to.is_in_group("Players") && !case_to.is_in_group("Enemis"):
									success = true
						if activeOverlay:
							list_positions.append(to_position)
						elif success:
								return true
	if success && activeOverlay:
		for pos in list_positions:
			map.add_overlay_cell_by_index(pos)
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
	return success

#static func blockConditions(var game):
static func block_action(var game):
	print("blockAction")
	game.current_playing_character().add_caracteristic("state", {"block": 1})
	game.end_turn()
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
static func up_and_down_action(var game):
	print("up and down Action")
	game.set_process(false)
	var map = game.map
	var enemi_position = yield(map, "overlay_clicked_from_map")
	var character = game.current_playing_character()
	var enemi = map.get_selectable_from_matrix(enemi_position)
	enemi.decrease_caracteristic("life", character.get_caracteristic("attack"))
	var character_position = character.position
	#cross
	character.set_position_in_matrix(enemi.behind(), map)
	enemi.set_caracteristic("orientation", enemi_position - character_position)
	map.disable_selection()
static func up_and_down_range_conditions(var game, var activeOverlay = false):
	var map = game.map
	var success = false
	var character = game.current_playing_character()
	var from_position = character.position
	var to_position
	var relative_position
	var zona = range(-1, character.caracteristics.nbMoves+2)
	for i in zona:
		for j in zona:
			relative_position = Vector3(i, 0, j)
			to_position = from_position + relative_position
			relative_position = relative_position.abs()
			if relative_position.x + relative_position.z <= 1 && map.is_inside_matrix_bounds(to_position):
				var selectable = map.get_selectable_from_matrix(to_position)
				if selectable && selectable.is_in_group("Enemis") && selectable.get_groups() != character.get_groups() && map.get_selectable_from_matrix(selectable.behind()) == null:
					if activeOverlay:
						map.add_overlay_cell_by_index(to_position)
						success = true
					else:
						return true
	return success
	

#static func passeConditions(var game):
#	var map = game.getMap()
#	return  map.testMatrixConditionFunction(funcref("res://RPGFightFramework/scripts/perso/actionPerso.gd", "deplacement_range_conditions"))
static func passe_action(var game):
	print("passe Action")
	game.set_process(false)
	var map = game.map
	var pos = yield(map, "overlay_clicked_from_map")
	var character = game.current_playing_character()
	var obj = character.drop_object_from_hand()
	map.disable_selection()
static func passe_range_conditions(var game, var activeOverlay = false):
	var map = game.map
	var success = false
	var character = game.current_playing_character()
#	if character.has_
	var from_position = character.position
	var to_position
	var relative_position
	var zona = range(-3, 4)
	for i in zona:
		for j in zona:
			relative_position = Vector3(i, 0, j)
			to_position = from_position + relative_position
			relative_position = relative_position.abs()
			if relative_position.x + relative_position.z <= 1 && map.is_inside_matrix_bounds(to_position):
				var selectable = map.get_selectable_from_matrix(to_position)
				if selectable && selectable.is_in_group("Players") && selectable.get_groups() != character.get_groups():
					if activeOverlay:
						map.add_overlay_cell_by_index(to_position)
						success = true
					else:
						return true
	return success
	
static func opportunity_attack_action(var game, var selectable):
	var map = game.map
	var character = game.current_playing_character()
static func opportunity_range_conditions(var game, var selectable, var activeOverlay = false):
	var map = game.map
	var success = false
	var target = game.current_playing_character()
	var from_position = selectable.position
	var to_position
	var relative_position
	var zona = range(-1, 2)
	for i in zona:
		for j in zona:
			relative_position = Vector3(i, 0, j)
			to_position = from_position + relative_position
			relative_position = relative_position.abs()
			if relative_position.x + relative_position.z <= 1 && map.is_inside_matrix_bounds(to_position) && map.get_selectable_from_matrix(to_position):
				#attention quand on gère plusieurs groupes
				if selectable && selectable == game.current_playing_character():
					if activeOverlay:
						map.add_overlay_cell_by_index(to_position)
						success = true
					else:
						return true
	return success

static func passer_action(var game):
	game.end_turn()
static func passer_range_conditions(var game, var activeOverlay = false):
	return true