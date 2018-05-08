extends Tree

########################################################################################################################################
###################################################		SIGNALS	########################################################################
########################################################################################################################################
signal changeMap

########################################################################################################################################
###################################################		MEMBERS	########################################################################
########################################################################################################################################
var m_selected = []
const TOOLS = preload("res://RPGFightFramework/scripts/modeler/tools.gd")
var m_mapLayout

########################################################################################################################################
###################################################		METHODS	########################################################################
########################################################################################################################################
func _ready():
	m_mapLayout = get_node("../..")
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
	
func searchSelectedCell(var column, var criterion):
	var node = null
	for cell in m_selected:
		if cell.get_text(0) == criterion:
			return cell

func getNameChildrenTreeItem(var item, var column):
	var child = item.get_children()
	var names = []
	while child:
		names.append(child.get_text(0))
		child = child.get_next()
	return names
	
func addCellItem(var vec):
	var child = create_item(get_root())
	print(get_root())
	print(child)
	child.set_text(0, String(vec))
	return child
	
func selectCellItem(var vec):
	var child = searchChildInTree(get_root(), 0, String(vec))
	if child:
		child.select(0)
		updateTreeSelected(child, true, vec)
		
func updateTreeSelected(var item, var selected, var vec):
	var map = m_mapLayout.m_map
	# Check if the precedents item are still item
	var size = m_selected.size()
	for i in range(size):
		var j = size - i - 1
		if !m_selected[j].is_selected(0):
			map.deselectOverlay(TOOLS.stringToVector3(m_selected[j].get_text(0)))
			m_selected.remove(j)
	if selected:
		map.selectOverlay(vec)
		if m_selected.find(item) == -1:
			m_selected.append(item)

func addCaracteristic(var cell, var carac):
	var cellChild = create_item(cell)
	cellChild.set_text(0, String(carac))
	
func addMapLevelDown(var cell, var mapName):
		var cellChild = create_item(cell)
		cellChild.set_text(0, mapName)
		cellChild.add_button(0, load("res://images/symboles/eye2.png"))
		
func addGroup(var cell, var group):
	var child = null
	for cellChild in cell:
		if cellChild.get_text(0) == "group":
			child = cellChild
			break
	if child:
		var node = create_item(child)
		node.set_text(0, String(group))
		
func clearTree():
	unselectAll()
	clear()
	
func unselectAll():
	var map = m_mapLayout.m_map
	var size = m_selected.size()
	for i in range(size):
		var j = size - i - 1
		map.deselectOverlay(TOOLS.stringToVector3(m_selected[j].get_text(0)))
		m_selected[j].deselect(0)
		m_selected.remove(j)

#func addSelectedCellsButton(var buttons):
#	var map = m_mapLayout.m_map
#	for cell in m_selected:
#		var carac = create_item(cell)
#		carac.set_cell_mode(0, TreeItem.CELL_MODE_STRING)
#		carac.set_text(0, String(buttons))
#		map.addCellCaracteristic(TOOLS.stringToVector3(cell.get_text(0)), caracteristic)


########################################################################################################################################
###################################################		SLOTS	########################################################################
########################################################################################################################################
func on_loadMap(var map):
	clearTree()
	create_item()
	set_hide_root(true)
	var matrix = map.m_matrix
	for i in range(matrix.size()):
		for j in (matrix[i].size()):
			for k in range(matrix[i][j].size()):
				var cell = matrix[i][j][k]
				if cell.has("overlay") && cell.overlay:
					var item = addCellItem(Vector3(i, j, k))
					if cell.has("modeler"):
						print(cell)
						if cell.modeler.has("carac"):
							for c in cell.modeler.carac:
								addCaracteristic(item, c)
						if cell.modeler.has("group"):
							for g in cell.modeler.group:
								addGroup(item, g)
						if cell.modeler.has("levelDown"):
							addMapLevelDown(item, cell.modeler.levelDown)

func _on_Tree_multi_selected(item, column, selected):
	var breakLoop = false
	var vec = null
	while(!breakLoop):
		var text = item.get_text(0)
		if TOOLS.isVector3(text):
			vec = TOOLS.stringToVector3(text)
			break
		if item.get_parent() == get_root():
			breakLoop = true
		else:
			item = item.get_parent()
	if vec:
		call_deferred("updateTreeSelected", item, selected, vec)
	accept_event()

func _on_Tree_button_pressed(item, column, id):
	var index = TOOLS.stringToVector3(item.get_parent().get_text(0))
	var matrix = m_mapLayout.m_map.m_matrix
	if id%2 == 0 && index != null:
		if matrix[index.x][index.y][index.z].has("levelDown") && matrix[index.x][index.y][index.z].levelDown:
			var map = get_node("../HBoxContainer/LevelMapsScrollContainer/GridContainer").getMap(matrix[index.x][index.y][index.z].levelDown)
			emit_signal("changeMap", map)
			
func on_addCaracteristic(var carac, var cellIndex):
	for cell in m_selected:
		addCaracteristic(cell, carac)

func on_addMapLevelDown(var cellIndex, var mapName):
	for cell in m_selected:
		addMapLevelDown(cell, mapName)
	
func on_addGroup(var group, var cellIndex):
	for cell in m_selected:
		addGroup(cell, group)

	
#func removeChildTreeItem(var item):
#	var child = item.get_children()
#	var nb = 0
#	while child:
#		nb += 1
#		var toDelete = child
#		child = child.get_next()
#		item.remove_child(toDelete)