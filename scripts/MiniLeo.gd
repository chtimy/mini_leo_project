extends Node2D

func _ready():
	print("miniLeo node : begin _ready function")
	var container = get_node("gridContainer")
	container.get_node("eye_symbol").hide()
	container.get_node("interact_symbol").hide()
	print("miniLeo node : end _ready function")

func _on_Area2D_area_entered( area ):
	print("miniLeo node : begin _on_Area2D_area_entered function")
	# each met character or objects
	var find = false
	var node = area
	while !find:
		if node.is_in_group("triggers"):
			find = true
		node = node.get_parent()
		if node == null:
			find = true
	get_node("gridContainer/eye_symbol").show()
	get_node("gridContainer/interact_symbol").show()
	print("miniLeo node : end _on_Area2D_area_entered function")

func _on_Area2D_area_exited( area ):
	print("miniLeo node : begin _on_Area2D_area_exited function")
	get_node("gridContainer/eye_symbol").hide()
	get_node("gridContainer/interact_symbol").hide()
	print("miniLeo node : end _on_Area2D_area_exited function")
	
func _input(event):
	if event.is_pressed():
		var overlappingAreas = get_node("sprite/Area2D").get_overlapping_areas()
		if overlappingAreas:
			# for each area, treat each one separately
			for overlappingArea in overlappingAreas:
				if event.is_action_pressed("ui_take"):
					overlappingArea.get_action("ui_take", null)

func on_grap_object_in_inventory(object):
	print("miniLeo node : begin on_grap_object_in_inventory function")		
	var overlappingAreas = get_node("sprite/Area2D").get_overlapping_areas()
	if overlappingAreas:
	# for each area, treat each one separately
		for overlappingArea in overlappingAreas:
			overlappingArea.get_action("ui_use_object_on", object)
	print("miniLeo node : end on_grap_object_in_inventory function")		
			