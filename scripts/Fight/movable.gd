extends "res://scripts/Fight/selectable.gd"

var position
var graphics

func _init(var name, var groups, var caracteristics, var graphics, var position).(name, groups, caracteristics):
	self.graphics = graphics
	self.position = position
	
func set_position_in_matrix(var position):
	self.position = position
	
func set_position(var position):
	var old_position = self.position
	set_position_in_matrix(position)
	translate_graphics(position - old_position)
	
func translate_graphics(var translation):
	self.graphics.transform.origin += translation
	
func set_graphics_position(var position):
	self.graphics.transform.origin = position
	
#func set_graphics_rotation_by_angle_in_degrees(var angle_in_degrees):
#	var angle_in_radians = angle_in_degrees * 2 * PI / 360.0
#	m_graphics.rotate_y(angle_in_radians)
	
func set_graphics_rotation_by_vec(var vec):
	var orientation = get_caracteristic("orientation")
	var way = orientation.cross(vec)
	var angle = orientation.angle_to(vec)
	if way.y < 0:
		angle = -angle
	self.graphics.rotate_y(angle)
	set_caracteristic("orientation", vec)
	
func set_graphics_rotation_to_target(var target):
	set_graphics_rotation_by_vec((target - self.position).normalized())