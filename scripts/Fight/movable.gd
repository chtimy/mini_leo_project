extends "res://scripts/Fight/selectable.gd"

var position

func _init(var name, var groups, var caracteristics, var position).(name, groups, caracteristics):
	self.position = position
	
func set_position_in_matrix(var position):
	self.position = position