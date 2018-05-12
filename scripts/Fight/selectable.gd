extends Node

var m_position

func _init(var name, var position, var category):
	set_name(name)
	m_position = position
	add_to_group(category)
	
func set_position_in_matrix(var position):
	m_position = position