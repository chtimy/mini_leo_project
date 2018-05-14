extends "res://RPGFightFramework/scripts/object.gd"

func _init(var name, var groups, var caracteristics, var position = null).(name, position, groups):
	pass

func scope():
	var tab = []
	for i in range(-1, 2):
		for j in range(-1, 2):
			if (i != 0 || j != 0):
				tab.append(Vector3(i, 0, j))
	return tab