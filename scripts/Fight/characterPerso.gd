extends "res://scripts/Fight/character.gd"

signal change_caracteristic_from_characterPerso
var m_caracteristics

func _init(var name, var position, var action_names, var category, var caracteristics, var graphics).(name, position, action_names, category, graphics):
	m_caracteristics = caracteristics
	randomize()
	
func get_caracteristic(var name):
	return m_caracteristics[name]

func set_caracteristic(var name, var value):
	m_caracteristics[name] = value
	emit_signal("change_caracteristic_from_characterPerso", {"name" : name, "value" : m_caracteristics[name]})
	
func add_caracteristic(name, value):
	m_caracteristics[name].append(value)
	emit_signal("change_caracteristic_from_characterPerso", {"name" : name, "value" : m_caracteristics[name]})
	
func increase_caracteristic(var name, var value):
	m_caracteristics[name] += value
	emit_signal("change_caracteristic_from_characterPerso", {"name" : name, "value" : m_caracteristics[name]})
	
func decrease_caracteristic(var name, var value):
	m_caracteristics[name] -= value
	emit_signal("change_caracteristic_from_characterPerso", {"name" : name, "value" : m_caracteristics[name]})
	
func throw_dice_for_caracteristic(var name):
	var result = throw_dice(100)
	return result <= m_caracteristics[name]
	
func throw_dice(var maxNumber):
	return randi() % maxNumber + 1
	
func set_rotation_by_vec(var vec):
	var angle = get_caracteristic("orientation").angle_to(vec)
	var way = get_caracteristic("orientation").cross(vec)
	if way.y < 0:
		angle = -angle
#	set_caracteristic("orientation", vec)
	m_graphics.rotate_y(angle)
	
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
	
	