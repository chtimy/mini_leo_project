extends Node

func _init(var name, var groups):
	set_name(name)
	for group in groups:
		add_to_group(group)