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


static func deplacement_action(var game, var selectable):
#	game.set_process(false)
#	var map = game.map
#	if game.current_playing_character().is_in_group("Enemis"):
#		map.set_mode(map.DRAW_ARROW, [character.position_in_matrix, ["Players"]])
#	else:
#		map.set_mode(map.DRAW_ARROW, [character.position_in_matrix, ["Enemis"]])
#	var path = yield(map, "move_from_map")
#	print(path)
#	map.disable_selection()
#	#data
#	var final_position = character.preprocess_path(path)
	var final_position = selectable.path.front()
	selectable.set_position_in_matrix(final_position)
	selectable.set_caracteristic("orientation", selectable.path.front() - selectable.path[1])
	
	#animation
	selectable.set_process(true)
	yield(selectable, "finished_animation_from_character")
	selectable.set_graphics_rotation_by_vec(selectable.get_caracteristic("orientation"), "wait")
	game.end_turn()
	
#static func deplacement_range_conditions(var game, var activeOverlay = false):
#	var map = game.map
#	var success = false
#	var character = game.current_playing_character()
#	var from_position = character.position_in_matrix
#	var to_position
#	var relative_position
#	var zona = range(-character.caracteristics.nbMoves, character.caracteristics.nbMoves+1)
#	for i in zona:
#		for j in zona:
#			relative_position = Vector2(i, j)
#			to_position = from_position + relative_position
#			relative_position = relative_position.abs()
#			if relative_position.x + relative_position.y <= character.caracteristics.nbMoves && map.is_inside_matrix_bounds(to_position):
#				var selectable = Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(to_position), "Characters")
#				if !selectable || selectable.is_in_group("objects"):
#					if activeOverlay:
#						map.add_overlay_cell_by_index(to_position)
#						success = true
#					else:
#						return true
#	return success
	
static func deplacement_range_conditions(var game):
	var map = game.map
	var character = game.current_playing_character()
	var from_position = character.position_in_matrix
	var to_position
	var relative_position
	var zona = range(-character.caracteristics.nbMoves, character.caracteristics.nbMoves+1)
	for i in zona:
		for j in zona:
			relative_position = Vector2(i, j)
			to_position = from_position + relative_position
			relative_position = relative_position.abs()
			if relative_position.x + relative_position.y <= character.caracteristics.nbMoves && map.is_inside_matrix_bounds(to_position):
				var selectable = Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(to_position), "Characters")
				if !selectable || selectable.is_in_group("objects"):
					map.add_overlay_cell_by_index(to_position)


static func attack_action(var game, var target):
	#data
	var character = game.current_playing_character()
	target.decrease_caracteristic("life", target.get_caracteristic("attack"))
	character.set_caracteristic("orientation", target.position_in_matrix - character.position_in_matrix)

	#animation
	var old_position = character.get_node("animation").position
	character.path = [old_position + character.get_caracteristic("orientation")*90]
	character.move_mode = "DIRECT"
	character.set_process(true)
	yield(character, "finished_animation_from_character")
	character.play_animation("attack_hand")
	yield(character, "finished_animation_from_character")
	character.path = [old_position]
	character.set_process(true)
	yield(character, "finished_animation_from_character")
	character.move_mode = "PATH"
	character.set_graphics_rotation_by_vec(character.get_caracteristic("orientation"), "wait")
	game.end_turn()
	
#static func attack_range_conditions(var game, var activeOverlay = false):
#	var map = game.map
#	var success = false
#	var character = game.current_playing_character()
#	var from_position = character.position_in_matrix
#	var to_position
#	var relative_position
#	var zona = range(-1, 2)
#	for i in zona:
#		for j in zona:
#			relative_position = Vector2(i, j)
#			to_position = from_position + relative_position
#			relative_position = relative_position.abs()
#			if relative_position.x + relative_position.y <= 1 && map.is_inside_matrix_bounds(to_position):
#				var selectable = Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(to_position), "Characters")
#				if selectable && (selectable.is_in_group("Players") || selectable.is_in_group("Enemis")) && selectable.get_groups() != character.get_groups():
#					if activeOverlay:
#						map.add_overlay_cell_by_index(to_position)
#						success = true
#					else:
#						return true
#	return success
	
static func attack_range_conditions(var game, var character_src):
	var character_dst = game.current_playing_character()
	var from_position = character_src.position_in_matrix
	var to_position = character_dst.position_in_matrix
	var dist = Tools.manhattan_dist(from_position, to_position)
	if dist <= 1:
		return true
	return false

static func posterize_action(var game, var target):
	#data
	var character = game.current_playing_character()
	character.set_caracteristic("orientation", target.position_in_matrix - character.position_in_matrix)
	target.set_caracteristic("orientation", character.position_in_matrix - target.position_in_matrix)
	
	target.set_position_in_matrix(character.front(2))
	character.set_position_in_matrix(character.front())
	target.decrease_caracteristic("life", character.get_caracteristic("attack"))
	if character.throw_dice_for_caracteristic("strength"):
		target.add_caracteristic("state", {"stunt": 1})
	Tools.clear_values()
	#animation
	character.set_graphics_rotation_by_vec(character.get_caracteristic("orientation"))
	character.set_graphics_position(character.position_in_matrix)
	target.set_graphics_position(target.position_in_matrix)
	target.set_graphics_rotation_by_vec(target.get_caracteristic("orientation"))
	game.end_turn()
	
#static func posterize_range_conditions(var game, var activeOverlay = false):
#	var map = game.map
#	var success = false
#	var character = game.current_playing_character()
#	var from_position = character.position_in_matrix
#	var to_position
#	var relative_position
#	var zona = range(-1, 2)
#	for i in zona:
#		for j in zona:
#			relative_position = Vector2(i, j)
#			to_position = from_position + relative_position
#			relative_position = relative_position.abs()
#			if relative_position.x + relative_position.y <= 1 && map.is_inside_matrix_bounds(to_position):
#				var selectable = Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(to_position), "Characters")
#				if selectable && (selectable.is_in_group("Players") || selectable.is_in_group("Enemis")) && selectable.get_groups() != character.get_groups():
#					if activeOverlay:
#						map.add_overlay_cell_by_index(to_position)
#						success = true
#					else:
#						return true
#	return success

static func posterize_range_conditions(var game, var character_src):
	var character_to = game.current_playing_character()
	var from_position = character_to.position_in_matrix
	var to_position = character_src.position_in_matrix
	if Tools.manhattan_dist(to_position, from_position) <= 1:
		return true
	return false

static func cross_action(var game, var target):
	print("crossAction")
	var enemi_position
	var character_position_to
	var character = game.current_playing_character()
	var enemi
	var map = game.map
	var tour = Tools.get_value("tour")
	
	while tour.number < 3:
		if !tour.treated:
			tour.treated = true
			var orientation = enemi_position - character.position_in_matrix
			var cases_to
			enemi = Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(enemi_position), "Characters")
			cases_to = [Tools.right(character.position_in_matrix, orientation), Tools.left(character.position_in_matrix, orientation), Tools.right(enemi_position, orientation), Tools.left(enemi_position, orientation)]
			for case_to in cases_to:
				var selectable = Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(case_to), "Characters")
				if !selectable || !selectable.is_in_group("Players") && !selectable.is_in_group("Enemis"):
					map.add_overlay_cell_by_index(case_to)
		game.set_process(false)
		map.set_mode(map.SELECTION_MODE)
		var pos = yield(map, "overlay_clicked_from_map")
		map.set_mode(map.NO_MODE)
		map.disable_selection()
		
		if tour.number < 2:
			enemi_position = pos
			
			tour.treated = false
		else:
			character_position_to = pos
		tour.number += 1
		

	#data
	character.set_position_in_matrix(character_position_to)
	var angle = (enemi.right() - enemi.position_in_matrix).angle_to(character.position_in_matrix - enemi.position_in_matrix)
	if (angle < PI/2.0 && angle > -PI/2.0):
		enemi.set_caracteristic("orientation", enemi.left() - enemi.position_in_matrix)
	else:
		enemi.set_caracteristic("orientation", enemi.right() - enemi.position_in_matrix)
	#si block
	var selectable = Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(enemi.front()), "Characters")
	#a ameliorer
	if (selectable && ((selectable.is_in_group("Players") && enemi.is_in_group("Enemis")) || (enemi.is_in_group("Players") && selectable.is_in_group("Enemis")))):
		var state = selectable.get_caracteristic("state")
		if state.has("block") && state.block > 0:
			if !enemi.throw_dice_for_caracteristics("perception"):
				enemi.decrease_caracteristic("life", enemi.get_caracteristic("attack"))
		else:
			selectable.decrease_caracteristic("life", enemi.get_caracteristic("attack"))
	Tools.clear_values()
	
	#animation
	character.set_graphics_rotation_by_vec(enemi_position - character.position_in_matrix)
	character.set_graphics_position(character.position_in_matrix)
	enemi.set_graphics_rotation_by_vec(enemi.get_caracteristic("orientation"))
	game.end_turn()
#fonction qui établit la range possible en fonction des caractéristiques également
#static func cross_range_conditions(var game, var activeOverlay = false):
#	var map = game.map
#	var success = false
#	var character = game.current_playing_character()
#	var from_position = character.position_in_matrix
#	var to_position
#	var relative_position
#	var list_positions = []
#	var list_positions2 = []
#	var zona = range(-1, 2)
#	for i in zona:
#		for j in zona:
#			relative_position = Vector2(i, j)
#			to_position = from_position + relative_position
#			relative_position = relative_position.abs()
#			if relative_position.x + relative_position.y <= 1 && map.is_inside_matrix_bounds(to_position):
#				var selectable = Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(to_position), "Characters")
#				if selectable && (selectable.is_in_group("Players") || selectable.is_in_group("Enemis")) && selectable.get_groups() != character.get_groups():
#					if selectable.get_caracteristic("orientation") == character.position_in_matrix - selectable.position_in_matrix:
#						if !success:
#							#espace autour du joueur
#							var cases_to = []
#							print(character.front())
#							cases_to.push_back(Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(character.front()), "Characters"))
#							cases_to.push_back(Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(character.behind()), "Characters"))
#							cases_to.push_back(Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(selectable.front()), "Characters"))
#							cases_to.push_back(Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(selectable.behind()), "Characters"))
#							for case_to in cases_to:
#								if !case_to || !case_to.is_in_group("Players") && !case_to.is_in_group("Enemis"):
#									success = true
#						if activeOverlay:
#							list_positions.append(to_position)
#						elif success:
#								return true
#	if success && activeOverlay:
#		for pos in list_positions:
#			map.add_overlay_cell_by_index(pos)
#		Tools.save_value("tour", {"treated" : true, "number" : 1})
#	return success
	
static func cross_range_conditions(var game, var character_src):
	var character_from = game.current_playing_character()
	var from_position = character_from.position_in_matrix
	var to_position = character_src.position_in_matrix
	var cases_to = []
	cases_to.push_back(Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(character.right()), "Characters"))
	cases_to.push_back(Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(character.left()), "Characters"))
	cases_to.push_back(Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(selectable.right()), "Characters"))
	cases_to.push_back(Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(selectable.left()), "Characters"))
	if Tools.manhattan_dist(from_position, to_position) != 1:
		if Tools.search_selectable_in_tab_by_group(game.map.get_selectables_from_cell()):
			 
		return false
	return true

static func steal_action(var game, var target):
	print("steal_action")
#	character.steal(enemi)
static func steal_range_conditions(var game, var activeOverlay = false):
#	var map = game.map
#	var matrix = map.matrix
#	var success = false
#	var character = game.current_playing_character()
#	var position
#	for i in range(matrix.size()):
#		for j in range(matrix[i].size()):
#			position = Vector3(i, j)
#			if ((character.position.x + 1 >= position.x && character.position.x - 1 <= position.x && character.position.z == position.z) || (character.position.z + 1 >= position.z && character.position.z - 1 <= position.z && character.position.x == position.x)) && map.on_surface(position):
#				var selectable = Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(position), "Characters")
#				if selectable && (selectable.is_in_group("Players") || selectable.is_in_group("Enemis")) && selectable.get_groups() != character.get_groups():
#					if activeOverlay:
#						map.add_overlay(position)
#						success = true
#					else:
#						return true
#	return success
	return true

static func block_action(var game, var target):
	print("blockAction")
	target.add_caracteristic("state", {"block": 1})
	game.end_turn()
static func block_range_conditions(var game, var activeOverlay = false):
	return true


#static func from_downtownConditions(var game):
static func from_downtown_action(var game, var target):
	print("from downtown Action")
	pass
static func from_downtown_range_conditions(var game, var activeOverlay = false):
#	var map = game.getMap()
#	var matrix = map.getMatrix()
#	var success = false
#	var character = game.current_playing_character()
#	var position
#	for i in range(matrix.size()):
#		for j in range(matrix[i].size()):
#			for k in range(matrix[i][j].size()):
#				position = Vector3(i, j, k)
#				if character.position.x + character.m_caracteristics.nbMoves >= position.x && character.position.x - character.m_caracteristics.nbMoves <= position.x && character.position.z + character.m_caracteristics.nbMoves >= position.z && character.position.z - character.m_caracteristics.nbMoves <= position.z && map.on_surface(position):
#					var selectable = game.getMap().get_selectable_from_matrix(position)
#					if selectable && (selectable.is_in_group("Players") || selectable.is_in_group("Enemis")) && selectable.get_groups() != character.get_groups():
#						if activeOverlay:
#							map.add_overlay(position)
#							success = true
#						else:
#							return true
#	if success && activeOverlay:
#		map.moveCursorTo(character.position)
#		map.setCursorVisible(true)
#	return success
	return true

static func up_and_under_action(var game, var target):
	print("up and down Action")
	#data
	var character = game.current_playing_character()
	target.decrease_caracteristic("life", character.get_caracteristic("attack"))
	character.set_position_in_matrix(target.behind())
#	target.set_caracteristic("orientation", enemi_position - character.position_in_matrix)
	
	#animation
	character.set_graphics_position(character.position_in_matrix)
#static func up_and_under_range_conditions(var game, var activeOverlay = false):
#	var map = game.map
#	var success = false
#	var character = game.current_playing_character()
#	var from_position = character.position_in_matrix
#	var to_position
#	var relative_position
#	var zona = range(-1, character.caracteristics.nbMoves+2)
#	for i in zona:
#		for j in zona:
#			relative_position = Vector2(i, j)
#			to_position = from_position + relative_position
#			relative_position = relative_position.abs()
#			if relative_position.x + relative_position.y <= 1 && map.is_inside_matrix_bounds(to_position):
#				var selectable = Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(to_position), "Characters")
#				if selectable && selectable.is_in_group("Enemis") && selectable.get_groups() != character.get_groups() && Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(selectable.behind()), "Characters") == null:
#					if activeOverlay:
#						map.add_overlay_cell_by_index(to_position)
#						success = true
#					else:
#						return true
#	return success
	
static func up_and_under_range_conditions(var game, var character_src):
	var character = game.current_playing_character()
	var from_position = character.position_in_matrix
	var to_position = character_src.position_in_matrix
	var distance = Tools.manhattan_dist(from_position, to_position)
	if distance == 1:
		return true
	return false
	

#static func passeConditions(var game):
#	var map = game.getMap()
#	return  map.testMatrixConditionFunction(funcref("res://RPGFightFramework/scripts/perso/actionPerso.gd", "deplacement_range_conditions"))
static func passe_action(var game, var target):
	print("passe Action")
#	var map = game.map
#	game.set_process(false)
#	map.set_mode(map.SELECTION_MODE)
#	var target_position = yield(map, "overlay_clicked_from_map")
#	map.set_mode(map.NO_MODE)
#	map.disable_selection()
#	if target_position == null:
#		return
	#data
	var character = game.current_playing_character()
	var obj = character.drop_object_from_hand()
#	var target = Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(target_position), "Characters")
#	if !target:
#		Tools.print_error("Error, the target doesn't exist")
#		return
	if target.throw_dice_for_caracteristic("perception"):
		target.take_in_hand(obj)
	else:
		game.drop_object_on_the_floor(obj, target.position_in_matrix)
	#animation
	game.end_turn()
	
#static func passe_range_conditions(var game, var activeOverlay = false):
#	var map = game.map
#	var character = game.current_playing_character()
#	if !character.has_object_in_hands():
#		return false
#	var success = false
#	var from_position = character.position_in_matrix
#	var to_position
#	var relative_position
#	var zona = range(-3, 4)
#	for i in zona:
#		for j in zona:
#			relative_position = Vector2(i, j)
#			to_position = from_position + relative_position
#			relative_position = relative_position.abs()
#			if relative_position.x + relative_position.y <= 4 && map.is_inside_matrix_bounds(to_position):
#				var selectable = Tools.search_selectable_in_tab_by_group(map.get_selectables_from_cell(to_position), "Characters")
#				if selectable && selectable.get_groups() == character.get_groups() && selectable != character:
#					if activeOverlay:
#						map.add_overlay_cell_by_index(to_position)
#						success = true
#					else:
#						return true
#	return success
	
static func passe_range_conditions(var game, var character_src):
	var character = game.current_playing_character()
	var from_position = character.position_in_matrix
	var to_position = character_src.position_in_matrix
	var distance = Tools.manhattan_dist(from_position, to_position)
	if distance <= 4:
		return true
	return false
	
static func opportunity_attack_action(var game, var character):
	var map = game.map
	var target = game.current_playing_character()
	if character.throw_dice_for_caracteristic("perception"):
		if !target.throw_dice_for_caracteristic("agility"):
			target.decrease_caracteristic("life", character.get_caracteristic("attack"))
			return true
	return false
			
#static func opportunity_attack_range_conditions(var game, var activeOverlay = false):
#	var map = game.map
#	var success = false
#	var target = game.current_playing_character()
#	var from_position = target.position
#	var to_position
#	var relative_position
#	var zona = range(-1, 2)
#	for i in zona:
#		for j in zona:
#			relative_position = Vector2(i, j)
#			to_position = from_position + relative_position
#			relative_position = relative_position.abs()
#			if relative_position.x + relative_position.y <= 1 && map.is_inside_matrix_bounds(to_position) && map.get_selectable_from_matrix(to_position):
#				#attention quand on gère plusieurs groupes
#				var selectable = map.get_selectable_from_matrix(to_position)
#				if selectable && selectable == game.current_playing_character():
#					if activeOverlay:
#						map.add_overlay_cell_by_index(to_position)
#						success = true
#					else:
#						return true
#	return success
	
static func opportunity_attack_range_conditions(var game, var character_src):
	var character = game.current_playing_character()
	var from_position = character.position_in_matrix
	var to_position = character_src.position_in_matrix
	var distance = Tools.manhattan_dist(from_position, to_position)
	if distance <= 1:
		return true
	return false

static func ramasser_action(var game, var target):
	var object = game.pick_object_from_the_floor(target.position_in_matrix)
	target.take_in_hand(object)
	game.end_turn()
	
#static func ramasser_range_conditions(var game, var activeOverlay = false):
#	var map = game.map
#	var success = false
#	var target = game.current_playing_character()
#	#attention quand on gère plusieurs groupes
#	var selectables = map.get_selectables_from_cell(target.position_in_matrix)
#	if selectables && Tools.search_selectable_in_tab_by_group(selectables, "Objects") != null:
#		return true
		
static func ramasser_range_conditions(var game, var character_src):
	var character_to = game.current_playing_character()
	var from_position = character_to.position_in_matrix
	var to_position = character_src.position_in_matrix
	var distance = Tools.manhattan_dist(from_position, to_position)
	if distance == 0:
		return true
	return false

static func passer_action(var game, var target):
	game.end_turn()
static func passer_range_conditions(var game, var character_src):
	return true