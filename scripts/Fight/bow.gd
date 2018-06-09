extends "res://RPGFightFramework/scripts/object.gd"

func _init(var name, var groups, var caracteristics, var position = null).(name, position, groups):
	pass

func scope():
	var tab = []
	for i in range(-3, 4):
		for j in range(-3, 4):
			if (i > 1 || i < -1) && (j > 1 || j < -1):
				tab.append(Vector3(i, 0, j))
	return tab