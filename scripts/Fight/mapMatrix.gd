extends "res://scripts/Fight/map.gd"

var overlay_cells = {}
var overlay_scene
var size_cell
var matrix

func _init(var size_cell).():
	self.size_cell = size_cell

#func add_instance_overlay():
#	var nb_instances = m_overlay_cells.get_multimesh().get_instance_count()
#	m_overlay_cells.get_multimesh().set_instance_count(nb_instances+1)
#	return nb_instances
	
func set_transform_overlay_mesh_instance(var index_instance, var position):
	var overlay = overlay_scene.instance()
	overlay_cells[index_instance] = overlay
	overlay.rect_position = position
	add_child(overlay)
	
func remove_overlay(var index_instance):
	remove_child(overlay_cells[index_instance])
	overlay_cells[index_instance].queue_free()
	overlay_cells[index_instance] = null
	

func set_color_overlay_mesh_instance(var index_instance, var color):
	if(overlay_cells[index_instance] != null):
		overlay_cells[index_instance].color = color
	
func get_overlay(var index):
	overlay_cells[index]

#func remove_all_overlays():
#	var nb_instances = m_overlay_cells.get_multimesh().get_instance_count()
#		set_transform_overlay_mesh_instance(list_active_overlays.pop_back(),Transform(Basis(), Vector3(-1000, -1000, -1000))) 