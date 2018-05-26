extends "res://scripts/Fight/movable.gd"

#########################################################################################################
########################################## SIGNALS ######################################################
#########################################################################################################

signal change_caracteristic_from_characterPerso
signal finished_animation_from_character
signal ask_around_possible_action_from_character

#########################################################################################################
########################################## ATTRIBUTES ######################################################
#########################################################################################################
var action_names
var opportunity_action_names
var path
var objects = []
var object_in_hand
var SPEED = 10
var map
var actions_dico
var image

#########################################################################################################
########################################## METHODS ######################################################
#########################################################################################################

func _init(var name, var groups, var caracteristics, var position, var action_names, var opp_action_names, var map, var image).(name, groups, caracteristics, position):
	self.action_names = action_names
	self.opportunity_action_names = opp_action_names
	self.map = map
	self.image = image
	add_to_group("Characters")
	randomize()
	
##################################### ACTIONS #############################################
# @function : do_opportunity_actions
# @Description : Check and make all opportunities actions
# @params :
#	game : Game node
# @return : True if an opportunity action was processing, false otherwise
func do_opportunity_actions(var game):
	for action_name in self.opportunity_action_names:
		var action = self.actions_dico.get_action(action_name)
		#if action.range_cond.call_func(game, true):
		return action.play.call_func(game, self)
# @function : preprocess_path
# @Description : Check for each point in the path, if there is an opportunity attack and resize
# 				 the path up to the last cell where is an opportunity action
# @params :
#	paths : Array of points composing the path
func preprocess_path(var paths):
	for i in range(paths.size()-1):
		var cell = paths[i]
		var neighbor = self.map.neighbor(self.position, [Vector3(1,0,0), Vector3(-1,0,0), Vector3(0,0,1), Vector3(0,0,-1)], ["Characters"])
		for neighbour in neighbor:
			if neighbour.do_opportunity_actions(get_node("..")):
				paths.resize(i)
				return 
		
##################################### GRAPHICS #############################################
func stop_moving():
	path.clear()
	
##################################### CARACTERISTICS #############################################
func increase_caracteristic(var name, var value):
	self.caracteristics[name] += value
	emit_signal("change_caracteristic_from_characterPerso", {"name" : name, "value" : self.caracteristics[name]})
	
func decrease_caracteristic(var name, var value):
	self.caracteristics[name] -= value
	emit_signal("change_caracteristic_from_characterPerso", {"name" : name, "value" : self.caracteristics[name]})
	
func throw_dice_for_caracteristic(var name):
	var result = tools.throw_dice(100)
	return result <= self.caracteristics[name]
	
##################################### NEIGHBOR #############################################
	
func behind(var i = 1):
	var orientation = get_caracteristic("orientation")
	return self.position_in_matrix - orientation * i
	
func front(var i = 1):
	var orientation = get_caracteristic("orientation")
	return self.position_in_matrix + orientation * i
	
func right(var i = 1):
	var orientation = get_caracteristic("orientation")
	return self.position_in_matrix + Vector3(orientation.z, 0, orientation.x)
	
func left(var i = 1):
	var orientation = get_caracteristic("orientation")
	return self.position_in_matrix + Vector3(-orientation.z, 0, -orientation.x)	
	
##################################### OBJECTS #############################################
# @function : receive_object
# @Description : Add the object to the own objects
# @params :
#	object : Input object to add
func receive_object(var object):
	objects.append(object)
	
# @function : drop_object
# @Description : Drop an object
# @params :
#	name : name of the own object to drop
# @return : Return the dropped object
func drop_object(var name):
	var object = null
	for i in range(self.objects.size()):
		if self.objects.name == name:
			object = self.objects[i]
			self.objects.remove(i)
			break
	return object
	
# @function : take_in_hand
# @Description : Put an own object in the hand of the character
# @params :
#	object : Object to put in the hands of the character
func take_in_hand(var object):
	if object_in_hand:
		drop_from_hand()
	object_in_hand = object

# @function : drop_from_hand
# @Description : Drop an object from the hands
# @return : The objet to drop, null if the object doesn't exist
func drop_object_from_hand():
	var obj = object_in_hand
	obj.set_position(self.position)
	object_in_hand = null
	return obj
	
# @function : has_object_in_hands
# @Description : Check if the character has an object in hands
# @return : True if the character has an object in hands, false otherwise
func has_object_in_hands():
	if object_in_hand != null:
		return true
	return false
##################################### NODE #############################################
func _ready():
	set_process(false)

func _process(delta):
	if path.size() > 1:
		var to_walk = delta * SPEED
		var from = path[path.size() - 1]
		while to_walk > 0 and path.size() >= 2:
			var pfrom = path[path.size() - 1]
			var pto = path[path.size() - 2]
			var d = pfrom.distance_to(pto)
			if d <= to_walk:
				path.remove(path.size() - 1)
				to_walk -= d
			else:
				path[path.size() - 1] = pfrom.linear_interpolate(pto, to_walk/d)
				to_walk = 0
		var atpos = path[path.size() - 1]
		var vec = atpos - from
		set_graphics_rotation_by_vec(vec.normalized())
		self.graphics.transform.origin += vec
	else:
		emit_signal("finished_animation_from_character")
		set_process(false)
