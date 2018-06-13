extends "res://scripts/Fight/movable.gd"

func _init(var name, var groups, var caracteristics, var position, var map).(name, groups, caracteristics, position, map):
	pass
	
func is_same_side(var selectable):
	if selectable.is_in_group("Objects"):
		return true
	return false