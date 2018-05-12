extends "res://scripts/Fight/selectable.gd"

var m_action_names
var m_graphics

func _init(var name, var position, var action_names, var category, var graphics).(name, position, category):
	m_graphics = graphics
	m_action_names = action_names
	
func set_position_in_matrix(var position, var map):
	.set_position_in_matrix(position)
	m_graphics.set_translation(map.get_selectable_position_from_matrix(position))
	
func set_rotation_by_angle(var angle):
	var angle_in_radians = angle * 2 * PI / 360.0
	m_graphics.rotate_y(angle_in_radians)
	
func set_rotation_by_vec(var vec):
	var angle = get_caracteristic("orientation").angle_to(vec)
	var way = get_caracteristic("orientation").cross(vec)
	if way.y < 0:
		angle = -angle
	set_caracteristic("orientation", vec)
	m_graphics.rotate_y(angle)

func set_rotation_to_target(var target):
	var vec = (Vector3(target.x, 0, target.z) - Vector3(m_position.x, 0, m_position.z)).normalized()
	set_rotation_by_vec(vec)

func _ready():
	self.add_child(m_graphics)
