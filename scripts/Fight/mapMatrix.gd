extends "res://scripts/Fight/map.gd"

var m_overlay_cells
var size_cell
var matrix

func _init().():
	pass
	
func get_size_cell():
	return self.size_cell

#func add_instance_overlay():
#	var nb_instances = m_overlay_cells.get_multimesh().get_instance_count()
#	m_overlay_cells.get_multimesh().set_instance_count(nb_instances+1)
#	return nb_instances
	
func set_transform_overlay_mesh_instance(var index_instance, var transform):
	m_overlay_cells.get_multimesh().set_instance_transform(index_instance, transform)

func set_color_overlay_mesh_instance(var index_instance, var color):
	m_overlay_cells.get_multimesh().set_instance_color(index_instance, color)
	
func get_overlay(var index):
	m_overlay_cells.get_multimesh().get_instance()[index]

#func remove_all_overlays():
#	var nb_instances = m_overlay_cells.get_multimesh().get_instance_count()
#		set_transform_overlay_mesh_instance(list_active_overlays.pop_back(),Transform(Basis(), Vector3(-1000, -1000, -1000))) 