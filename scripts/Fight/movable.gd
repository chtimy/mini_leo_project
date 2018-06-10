extends "res://scripts/Fight/selectable.gd"

var position_in_matrix
var size_tile
var map

func _init(var name, var groups, var caracteristics, var position, var map).(name, groups, caracteristics):
	self.position_in_matrix = position
	self.map = map
	
func set_position_in_matrix(var position_to):
	map.move_selectable_to(self, position_in_matrix, position_to)
	position_in_matrix = position_to
	
func translate_graphics(var translation):
	$animation.position += translation
	
func set_graphics_position(var position):
	$animation.position = position * map.size_cell
	
#func set_graphics_rotation_by_angle_in_degrees(var angle_in_degrees):
#	var angle_in_radians = angle_in_degrees * 2 * PI / 360.0
#	m_graphics.rotate_y(angle_in_radians)
	
func set_graphics_rotation_by_vec(var vec, var anim):
	if vec == Vector2(1, 0):
		$animation.set_animation(anim + "_right")
	elif vec == Vector2(-1, 0):
		$animation.set_animation(anim + "_left")
	elif vec == Vector2(0, 1):
		$animation.set_animation(anim + "_front")
	elif vec == Vector2(0, -1):
		$animation.set_animation(anim + "_back")
	
func set_graphics_rotation_to_target(var target):
	set_graphics_rotation_by_vec((target - self.position).normalized())