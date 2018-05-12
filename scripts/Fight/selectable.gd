extends Node

var position

func _init(var name, var position, var category):
	set_name(name)
	self.position = position
	add_to_group(category)
	
func set_position_in_matrix(var position):
	self.position = position