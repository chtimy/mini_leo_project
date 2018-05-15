extends "res://scripts/Fight/movable.gd"

signal change_caracteristic_from_characterPerso

var m_action_names
var m_graphics
var objects = []
var object_in_hand

func _init(var name, var groups, var caracteristics, var position, var action_names, var graphics).(name, groups, caracteristics, position):
	m_graphics = graphics
	m_action_names = action_names
	randomize()
	
func set_position_in_matrix(var position, var map):
	var old_position = self.position
	.set_position_in_matrix(position)
	m_graphics.transform.origin += map.get_selectable_position_from_matrix(position) - map.get_selectable_position_from_matrix(old_position)
func set_rotation_by_angle(var angle):
	var angle_in_radians = angle * 2 * PI / 360.0
	m_graphics.rotate_y(angle_in_radians)
func set_rotation_to_target(var target):
	var vec = (Vector3(target.x, 0, target.z) - Vector3(self.position.x, 0, self.position.z)).normalized()
	set_rotation_by_vec(vec)
	
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
	
func set_rotation_by_vec(var vec):
	var angle = get_caracteristic("orientation").angle_to(vec)
	var way = get_caracteristic("orientation").cross(vec)
	if way.y < 0:
		angle = -angle
#	set_caracteristic("orientation", vec)
	m_graphics.rotate_y(angle)
	
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

func _ready():
	self.add_child(m_graphics)
