extends Tree

signal changeMapLayout

var m_selected = []

const TOOLS = preload("res://RPGFightFramework/scripts/modeler/tools.gd")

var m_mapLayout

func _ready():
	m_mapLayout = get_node("../..")
	print("map : ", m_mapLayout)

	set_columns(1)
	set_custom_minimum_size(Vector2(0,200))
	var root = create_item()
	set_hide_root(true)
	
func searchChildInTree(var item, var column, var criterion):
	var child = item.get_children()
	var node = null
	while child:
		if child.get_text(0) == criterion:
			node = child
			break
		child = child.get_next()
	return node
	
func getNameChildrenTreeItem(var item, var column):
	var child = item.get_children()
	var names = []
	while child:
		names.append(child.get_text(0))
		child = child.get_next()
	return names
	
func _on_Tree_button_pressed(item, column, id):
	var index = TOOLS.stringToVector3(item.get_parent().get_text(0))
	var matrix = m_mapLayout.m_map.m_matrix
	if index != null:
		if matrix[index.x][index.y][index.z].has("levelDown") && matrix[index.x][index.y][index.z].levelDown:
			emit_signal("changeMapLayout", matrix[index.x][index.y][index.z].levelDown)
			

#func removeChildTreeItem(var item):
#	var child = item.get_children()
#	var nb = 0
#	while child:
#		nb += 1
#		var toDelete = child
#		child = child.get_next()
#		item.remove_child(toDelete)

func _on_Tree_cell_selected():
	pass
#	var selected = get_selected()
#	var breakLoop = false
#	var vec = null
#	while(!breakLoop):
#		var text = selected.get_text(0)
#		if TOOLS.isVector3(text):
#			vec = TOOLS.stringToVector3(text)
#			break
#		if selected.get_parent() == get_root():
#			breakLoop = true
#		else:
#			selected = selected.get_parent()
#	if vec:
#		call_deferred("on_Tree_cell_selected_differed", selected, vec)
		
func on_Tree_cell_selected_differed(var selected, var vec):
	var map = m_mapLayout.m_map
	# Check if the precedents selected are still selected
	for i in range(m_selected.size()):
		var j = m_selected.size() - i - 1
		if m_selected[j] != selected && !m_selected[j].is_selected(0):
			map.deselectOverlay(TOOLS.stringToVector3(m_selected[j].get_text(0)))
			m_selected.remove(j)
	map.selectOverlay(vec)
	m_selected.append(selected)
	print("m_semlected")
	for selected in m_selected:
		print(selected.get_text(0))
	print("cell selected")
		


func _on_Tree_multi_selected(item, column, selected):
	print("multi ", item, " " , selected)
