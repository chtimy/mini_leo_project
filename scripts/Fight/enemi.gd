extends "res://scripts/Fight/character.gd"


func _init(var name, var position, var action_names, var opportunity_attack_names, var groups, var caracteristics, var map, var image).(name, position, action_names, opportunity_attack_names, groups, caracteristics, map, image):
	pass
	
func same_side(var selectable):
	if selectable.is_in_group("Enemis"):
		return true
	return false