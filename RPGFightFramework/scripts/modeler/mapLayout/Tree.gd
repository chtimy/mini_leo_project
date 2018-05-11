extends Tree

########################################################################################################################################
###################################################		SIGNALS	########################################################################
########################################################################################################################################
signal changeMap
signal addGroupSignal
signal addLevelDownSignal
signal addCaracteristicSignal

########################################################################################################################################
###################################################		MEMBERS	########################################################################
########################################################################################################################################
var m_selected = []
const TOOLS = preload("res://RPGFightFramework/scripts/modeler/tools.gd")

########################################################################################################################################
###################################################		METHODS	########################################################################
########################################################################################################################################
func _ready():
	set_columns(1)
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
	child.set_text(0, String(vec))
	return child
	
func selectCellItem(var vec):
	var child = searchChildInTree(get_root(), 0, String(vec))
	if child:
		child.select(0)
		updateTreeSelected(child, true, vec)
		
func updateTreeSelected(var item, var selected, var vec):
	var map = get_parent().m_map
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

func addCaracteristic(var item, var carac):
	var itemChild = create_item(item)
	itemChild.set_text(0, String(carac))
	
func addMapLevelDown(var item, var mapName):
		var itemChild = create_item(item)
		itemChild.set_text(0, "Level down : " + mapName)
		itemChild.add_button(0, load("res://images/symboles/eye2.png"))
		
func addGroup(var item, var group):
	var child = null
	var itemChild = item.get_children()
	while itemChild:
		if itemChild.get_text(0) == "group":
			child = itemChild
			break
		itemChild = itemChild.get_next()
	if !child:
		child = create_item(item)
		child.set_text(0, "group")
	var node = create_item(child)
	node.set_text(0, String(group))
		
func clearTree():
	unselectAll()
	clear()
	
func unselectAll():
	var map = get_parent().m_map
	var size = m_selected.size()
	for i in range(size):
		var j = size - i - 1
		map.deselectOverlay(TOOLS.stringToVector3(m_selected[j].get_text(0)))
		m_selected[j].deselect(0)
		m_selected.remove(j)
		
func getInformation(var informations = [], var node = get_root()):
	var map = get_parent().m_mapRoot
	var child = node.get_children()
	while child:
		var coords = TOOLS.stringToVector3(child.get_text(0))
		coords = coords - map.m_originModeler
		informations.append({"coords" : coords})
		var index = informations.size() - 1
		var childchild = child.get_children()
		while childchild:
			if childchild.get_text(0) == "group":
				informations[index]["group"] = []
				var group = childchild.get_children()
				while group:
					informations[index].group.append(group.get_text(0))
					group = group.get_next()
			elif TOOLS.isLevelDown(childchild.get_text(0)):
				var tree = load("res://RPGFightFramework/scenes/modeleur/Tree.tscn").instance()
				tree.create_item()
				tree.loadMap(get_node("../HBoxContainer/LevelMapsScrollContainer/GridContainer").getMap(TOOLS.getPathLevelDown(childchild.get_text(0))))
				informations[index]["levelDown"] = getInformation([], tree.get_root())
				tree.queue_free()
			else :
				if !informations[index].has("carac"):
					informations[index]["carac"] = []
				informations[index].carac.append(childchild.get_text(0))
			childchild = childchild.get_next()
		child = child.get_next()
	return informations
				
func loadMap(var map):
	var matrix = map.m_matrix
	for i in range(matrix.size()):
		for j in (matrix[i].size()):
			for k in range(matrix[i][j].size()):
				var cell = matrix[i][j][k]
				if cell.has("overlay") && cell.overlay:
					var item = addCellItem(Vector3(i, j, k))
					if cell.has("modeler"):
						if cell.modeler.has("carac"):
							for c in cell.modeler.carac:
								addCaracteristic(item, c)
						if cell.modeler.has("group"):
							for g in cell.modeler.group:
								addGroup(item, g)
						if cell.modeler.has("levelDown"):
							addMapLevelDown(item, cell.modeler.levelDown)

func on_loadMap(var map):
	clearTree()
	create_item()
	set_hide_root(true)
	loadMap(map)
	var signals = get_signal_connection_list("addGroupSignal")
	for sig in signals:
		sig.source.disconnect(sig.signal, sig.target, sig.method)
	signals = get_signal_connection_list("addLevelDownSignal")
	for sig in signals:
		sig.source.disconnect(sig.signal, sig.target, sig.method)
	signals = get_signal_connection_list("addCaracteristicSignal")
	for sig in signals:
		sig.source.disconnect(sig.signal, sig.target, sig.method)
	connect("addGroupSignal", map, "on_addGroup")
	connect("addLevelDownSignal", map, "on_addMapLevelDown")
	connect("addCaracteristicSignal", map, "on_addCaracteristic")

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
	var matrix = get_parent().m_map.m_matrix
	if id%2 == 0 && index != null:
		if matrix[index.x][index.y][index.z].has("levelDown") && matrix[index.x][index.y][index.z].levelDown:
			var map = get_node("../HBoxContainer/LevelMapsScrollContainer/GridContainer").getMap(matrix[index.x][index.y][index.z].levelDown)
			emit_signal("changeMap", map)
			
func on_addCaracteristic(var carac):
	for item in m_selected:
		addCaracteristic(item, carac)
		emit_signal("addCaracteristicSignal", TOOLS.stringToVector3(item.get_text(0)), carac)

func on_addMapLevelDown(var mapName):
	for item in m_selected:
		addMapLevelDown(item, mapName)
		emit_signal("addLevelDownSignal", TOOLS.stringToVector3(item.get_text(0)), mapName)
	
func on_addGroup(var group):
	for item in m_selected:
		addGroup(item, group)
		emit_signal("addGroupSignal", TOOLS.stringToVector3(item.get_text(0)), group)

	
#func removeChildTreeItem(var item):
#	var child = item.get_children()
#	var nb = 0
#	while child:
#		nb += 1
#		var toDelete = child
#		child = child.get_next()
#		item.remove_child(toDelete)