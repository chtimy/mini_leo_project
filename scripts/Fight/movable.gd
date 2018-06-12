extends "res://scripts/Fight/selectable.gd"

signal finished_animation_from_character

var position_in_matrix
var size_tile
var map

var move_mode
var path
var SPEED = 3

func _init(var name, var groups, var caracteristics, var position, var map).(name, groups, caracteristics):
	self.position_in_matrix = position
	self.map = map
	self.move_mode = "PATH"
	
func set_move_mode(var mode):
	self.move_mode = mode
	
func set_position_in_matrix(var position_to):
	map.move_selectable_to(self, position_in_matrix, position_to)
	position_in_matrix = position_to
#	$animation.set_z_index(position_in_matrix.y)
	
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

func get_animation_orientation():
	var vec = get_caracteristic("orientation")
	if vec == Vector2(1, 0):
		return "right"
	elif vec == Vector2(-1, 0):
		return "left"
	elif vec == Vector2(0, 1):
		return "front"
	elif vec == Vector2(0, -1):
		return "back"
		
func set_graphics_rotation_to_target(var target):
	set_graphics_rotation_by_vec((target - self.position).normalized())

func _process(delta):
	if move_mode == "PATH":
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
			var vec = map.index_to_position(atpos) - map.index_to_position(from)
			set_graphics_rotation_by_vec(vec.normalized(), "walk")
			translate_graphics(vec)
		else:
			emit_signal("finished_animation_from_character")
			set_process(false)
	elif move_mode == "DIRECT":
		var from = $animation.position
		var to = path[0]
		var dist = to - from
		var move = SPEED * 10 * dist.normalized() * delta
		if from.distance_to(to) > move.length():
			set_graphics_rotation_by_vec(move.normalized(), "walk")
			translate_graphics(move)
		else:
			translate_graphics(dist)
			emit_signal("finished_animation_from_character")
			set_process(false)
	