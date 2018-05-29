extends "res://scripts/Fight/selectable.gd"

var position_in_matrix
var size_tile

func _init(var name, var groups, var caracteristics, var position).(name, groups, caracteristics):
	self.position_in_matrix = position
	
func set_position(var position):
	var old_position = self.position_in_matrix
	set_position_in_matrix(position_in_matrix)
	translate_graphics(position - old_position)
	
func translate_graphics(var translation):
	$animation.position += translation
	
func set_graphics_position(var position):
	$animation.position = position
	
#func set_graphics_rotation_by_angle_in_degrees(var angle_in_degrees):
#	var angle_in_radians = angle_in_degrees * 2 * PI / 360.0
#	m_graphics.rotate_y(angle_in_radians)
	
func set_graphics_rotation_by_vec(var vec):
	if vec == Vector2(1, 0):
		$animation.set_animation("wait_right")
	elif vec == Vector2(-1, 0):
		$animation.set_animation("wait_left")
	elif vec == Vector2(0, 1):
		$animation.set_animation("wait_front")
	elif vec == Vector2(0, -1):
		$animation.set_animation("wait_back")
	
func set_graphics_rotation_to_target(var target):
	set_graphics_rotation_by_vec((target - self.position).normalized())