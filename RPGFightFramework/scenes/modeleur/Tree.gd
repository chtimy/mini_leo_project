extends Tree

var m_mapLayout

func _ready():
	m_mapLayout = get_tree().get_root()
	
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
			