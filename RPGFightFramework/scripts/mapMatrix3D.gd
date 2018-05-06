extends "res://RPGFightFramework/scripts/mapMatrix.gd"

var m_matrix

func _init().():
	pass
	
#func activeOverlays(var rangeCond, var game):
#	print("activeoverlay")
#	var matrix = m_map.m_matrix
#	for i in range(matrix.size()):
#		for j in range(matrix[i].size()):
#			for k in range(matrix[i][j].size()):
#				if rangeCond.call_func(game, Vector3(i, j, k)):
#					addOverlay(Vector3(i, j, k))
	
func testMatrixConditionFunction(var rangeCond, var game):
	for i in range(m_matrix.size()):
		for j in range(m_matrix[i].size()):
			for k in range(m_matrix[i][j].size()):
				if rangeCond.call_func(game, Vector3(i, j, k)):
					return true
	return false

func chooseTile():
	if Input.is_action_just_released("ui_take"):
		if isCaseOverlayed(m_cursor.position):
			return m_cursor.position
	elif Input.is_action_just_released("ui_down"):
		if insideMatrix(m_cursor.position + Vector3(0,0,1)):
			moveCursorTo(m_cursor.position + Vector3(0,0,1))
	elif Input.is_action_just_released("ui_up"):
		if insideMatrix(m_cursor.position + Vector3(0,0,-1)):
			moveCursorTo(m_cursor.position + Vector3(0,0,-1))
	elif Input.is_action_just_released("ui_right"):
		if insideMatrix(m_cursor.position + Vector3(1,0,0)):
			moveCursorTo(m_cursor.position+ Vector3(1,0,0))
	elif Input.is_action_just_released("ui_left"):
		if insideMatrix(m_cursor.position + Vector3(-1,0,0)):
			moveCursorTo(m_cursor.position+ Vector3(-1,0,0))
	return null

# @function : isCellOverlayed
# @Description : Check whether the cell is overlayed
# @params :
#	index : Index in the matrix of the cell
func isOverlayCellAtIndex(var index):
	if m_matrix[index.x][index.y][index.z].has("overlay") && m_matrix[index.x][index.y][index.z].overlay:
		return true
	return false

# @function : moveCursorTo
# @Description : Move the cursor to the input index position in the matrix
# @params :
#	index : Destination index in the matrix of the cell
func moveCursorTo(var index):
	m_cursor.index = index
	m_cursor.mesh.set_translation(getObjectPosition(index) - Vector3(0,0.35,0))

# @function : disableSelection
# @Description : Remove all the overlay cells and hide the cursor
func disableSelection():
	setCursorVisible(false)
	removeAllOverlayCells()

# @function : removeAllOverlayCells
# @Description : Remove all the overlay cells in the map
func removeAllOverlayCells():
#	for i in range(m_matrix.size()):
#		for j in range(m_matrix[i].size()) :
#			for k in range(m_matrix[i][j].size()):
#				if m_matrix[i][j][k].has("overlay") and m_matrix[i][j][k].overlay:
#					m_matrix[i][j][k].overlay.queue_free()
#					m_matrix[i][j][k].overlay = null
	for i in range(m_matrix.size() * m_matrix[0].size() * m_matrix[0][0].size()):
		var t = Transform(Basis(), Vector3(-1000, -1000, -1000))
		m_overlayCells.get_multimesh().set_instance_transform(i, t)

# @function : addOverlayCellByIndex
# @Description : Add overlay cell to the input index destination. 
#	No verification if the index in in the bound of the matrix
# @params :
#	index : Index in the matrix of the cell to add the overlay cell
func addOverlayCellByIndex(var index):
	if !m_matrix[index.x][index.y][index.z].has("overlay") || m_matrix[index.x][index.y][index.z].overlay == null:
#		var overlayIndex = addInstanceOverlay()
		var transform = Transform(Basis(), indexToPosition(index))
		# ATTENTION ici à l'offset de déplacement
#		transform.origin = indexToPosition(index)
		setTransformOverlayMeshInstance(index3DToindex1D(index), transform)
#		print(m_overlayCells.get_multimesh().get_instance_transform(0))
		m_matrix[index.x][index.y][index.z].overlay = true
		return true
	return false
#	add_child(overlay)
func index3DToindex1D(var index3D):
	return index3D.y * m_matrix[0].size() * m_matrix[0][0].size() + index3D.x * m_matrix[0][0].size() + index3D.z
# @function : func addOverlayCellByPosition(var position):
# @Description : Add overlay cell to the input position destination (position is normalized to the center of the cell). 
#	No verification if the index in in the bound of the matrix
# @params :
#	postition : Position of the overlay cell on the map
func addOverlayCellByPosition(var position):
	var index = positionToIndex(position)
	return addOverlayCellByIndex(index)
	
func getOverlay(var index):
	.getOverlay(index3DToindex1D(index))
	
func setColorOverlayMeshInstance(var indexInstance, var color):
	.setColorOverlayMeshInstance(index3DToindex1D(indexInstance), color)
	
func positionToIndex(var position):
	var pos = (position - m_origin) / m_sizeCell
	return Vector3(round(pos.x), round(pos.y), round(pos.z))
func indexToPosition(var index):
	return index * m_sizeCell + m_origin

# @function : insideMatrix
# @Description : Test if the input index is inside the matrix bound
# @params :
#	index : Index to check if inside the matrix bound
# @return
#	True if the index is inside the matrix bound, false otherwise
func isInsideMatrixBounds(var index):
	if index.x >= m_matrix.size() || index.x < 0 || index.y >= m_matrix[index.x].size() || index.y < 0|| index.z >= m_matrix[index.x][index.y].size() || index.z < 0:
		return false
	return true

# @function : isCellContainsSelectable
# @Description : Check if the cell contains a selectable
# @params :
#	index : Index of the cell to check if there is a selectable
# @return :
#	True if the cell contains a selectable, false otherwise
# a completer au fur et a mesure des types de case
#du moins à modifier et faire en fct des catégories
func isCellContainsSelectable(var index):
	if !m_matrix[index.x][index.y][index.z].has("selectable") || m_matrix[index.x][index.y][index.z].selectable == null:
		return true
	return false

# @function : addSelectableToCell
# @Description : Add a selectable to the cell with the input index
# @params :
#	selectable : Selectable to add to the cell
#	index : Index of the cell to add a selectable
# a completer au fur et a mesure des types de case
#du moins à modifier et faire en fct des catégories
func addSelectableToCell(var selectable, var index):
	m_matrix[index.x][index.y][index.z].selectable = selectable

# @function : moveSelectableTo
# @Description : Move a selectable from a cell to another cell in the map
# @params :
#	indexFrom : Index of the cell to move away the selectable
#	indexTo : Index of the cell to move in the selectable
#move the selectable to the new position . BE CAREFUL : don't move the graphics selectable
func moveSelectableTo(var indexFrom, var indexTo):
	# don't check if the final position is busy by something or not
	if isCellContainsSelectable(indexFrom):
		m_matrix[indexTo.x][indexTo.y][indexTo.z].selectable = m_matrix[indexFrom.x][indexFrom.y][indexFrom.z].selectable
		clearCell(indexFrom)
		return true
	return false

# @function : removeSelectableFromCell
# @Description : Remove a selectable from the cell. Just set cell.selectable to null
# @params :
#	index : Index of the cell to remove the selectable
func removeSelectableFromCell(var index):
	m_matrix[index.x][index.y][index.z].selectable = null

# @function : getSelectableFromMap
# @Description : Get the selectable in the map with the input index
# @params :
#	index : Index in the map of the selectable
# @return
#	The selectable if exists at the index position, null otherwise
func getSelectableFromMatrix(var index):
	if !isCellContainsSelectable(index):
		return null
	return m_matrix[index.x][index.y][index.z].selectable

# @function : getSelectablePosition
# @Description : Get the position in the map of the selectable with the input index
# @params :
#	index : Index in the matrix of the selectable
# @return
#	The position of the selectable on the map
func getSelectablePosition(var index):
	var sizeElement = getSizeCell()
	var y = index.y
	while(insideMatrix(Vector3(index.x, y, index.z)) and m_matrix[index.x][y][index.z].type != 0):
		y+=1
	y-=index.y
	# ATTENTION : ici 0.75...
	return getOrigin() + index * sizeElement + Vector3(0, sizeElement*y*0.75,0)
	
func on_surface(position):
	if (position.y == 0 and m_matrix[position.x][position.y][position.z].type == 0 ) or ( insideMatrix(Vector3(position.x, position.y+1, position.z)) and m_matrix[position.x][position.y+1][position.z].type == 0 && m_matrix[position.x][position.y][position.z].type != 0 ) :
		return true
	return false

#func _ready():
#	add_child(m_cursor.mesh)
#	add_child(m_map)
#	#cursor to choose the tile
#	m_cursor = Sprite.new()
#	m_cursor.set_texture(load(mapDescr.cursorTexturePath))
#	m_cursor.set_scale(m_tileSize/m_cursor.get_texture().get_size().x)
#	m_cursor.set_centered(false)
#	m_cursor.set_position(Vector2(0, 0))
#	m_cursor.set_visible(false)
#	m_cursor.set_z_index(3)
#	add_child(m_cursor)