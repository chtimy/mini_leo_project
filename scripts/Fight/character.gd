extends "res://scripts/Fight/movable.gd"

signal change_caracteristic_from_characterPerso
signal finished_animation_from_character
signal ask_around_possible_action_from_character

var m_action_names
var opportunity_action_names
var m_graphics
var path
var objects = []
var object_in_hand
var SPEED = 10
var map
var actions_dico
var image

func _init(var name, var groups, var caracteristics, var position, var action_names, var opp_action_names, var graphics, var map, var image).(name, groups, caracteristics, position):
	m_graphics = graphics
	m_action_names = action_names
	self.opportunity_action_names = opp_action_names
	print(self.opportunity_action_names)
	self.map = map
	self.image = image
	add_to_group("Characters")
	randomize()

func do_opportunity_actions(var game):
	for action_name in self.opportunity_action_names:
		var action = self.actions_dico.get_action(action_name)
		#if action.range_cond.call_func(game, true):
		action.play.call_func(game, self)
	#return false

func stop_moving():
	path.clear()

func set_position(var position, var map):
	var old_position = self.position
	.set_position_in_matrix(position)
	translate_graphics(position - old_position)
	
func translate_graphics(var translation):
	m_graphics.transform.origin += translation
	
func set_graphics_position(var position):
	m_graphics.transform.origin = position
	
func set_graphics_rotation_by_angle_in_degrees(var angle_in_degrees):
	var angle_in_radians = angle_in_degrees * 2 * PI / 360.0
	m_graphics.rotate_y(angle_in_radians)
	
func set_graphics_rotation_by_vec(var vec):
	var orientation = get_caracteristic("orientation")
	var way = orientation.cross(vec)
	var angle = orientation.angle_to(vec)
	if way.y < 0:
		angle = -angle
	m_graphics.rotate_y(angle)
	set_caracteristic("orientation", vec)
	
#func set_graphics_rotation_to_target(var target):
#	var vec = (Vector3(target.x, 0, target.z) - Vector3(self.position.x, 0, self.position.z)).normalized()
##	print("direction : ", vec)
#	set_rotation_by_vec(vec)
	
func increase_caracteristic(var name, var value):
	self.caracteristics[name] += value
	emit_signal("change_caracteristic_from_characterPerso", {"name" : name, "value" : self.caracteristics[name]})
	
func decrease_caracteristic(var name, var value):
	self.caracteristics[name] -= value
	emit_signal("change_caracteristic_from_characterPerso", {"name" : name, "value" : self.caracteristics[name]})
	
func throw_dice_for_caracteristic(var name):
	var result = throw_dice(100)
	return result <= self.caracteristics[name]

static func throw_dice(var maxNumber):
	return randi() % maxNumber + 1
	
func behind(var i = 1):
	var orientation = get_caracteristic("orientation")
	return self.position - orientation * i
	
func front(var i = 1):
	var orientation = get_caracteristic("orientation")
	return self.position + orientation * i
	
func right(var i = 1):
	var orientation = get_caracteristic("orientation")
	return self.position + Vector3(orientation.z, 0, orientation.x)
	
func left(var i = 1):
	var orientation = get_caracteristic("orientation")
	return self.position + Vector3(-orientation.z, 0, -orientation.x)	
	
func receive_object(var object):
	objects.append(object)
	
func drop_object(var name):
	var object = null
	for i in range(self.objects.size()):
		if self.objects.name == name:
			object = self.objects[i]
			self.objects.remove(i)
			break
	return object
	
func take_in_hand(var object):
	object_in_hand = object
	
func drop_from_hand():
	var obj = object_in_hand
	object_in_hand = null
	return obj
	
#func do_opportunity_actions():
#	for action in opportunity_action_names:
#		self.actions_dico.action()
	
func _ready():
	self.add_child(m_graphics)
	set_process(false)

func _process(delta):
	if path.size() > 1:
		self.map.ask_around_possible_action(self)
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
			m_graphics.transform.origin += vec
	else:
		emit_signal("finished_animation_from_character")
		set_process(false)
