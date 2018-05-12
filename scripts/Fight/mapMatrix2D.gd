extends "res://RPGFightFramework/scripts/mapMatrix.gd"

#func _init(var map).(map):
#	pass
#
#func activeOverlays(var rangeCond, var toolFunctions, var characters, var currentCharacterIndex, var objects):
#	var matrix = m_map.m_matrix
#	for i in range(matrix.size()):
#		for j in range(matrix[i].size()):
#			if rangeCond.call_func(characters, currentCharacterIndex, objects, Vector2(i, j), toolFunctions):
#				m_mat[i][j].overlay = 1
#				addOverlay(Vector2(i, j))
#
#func chooseTile():
#	m_cursor.mesh.set_visible(true)
#	if Input.is_action_just_released("ui_take"):
#		if isCaseOverlayed(m_cursor.position):
#			return m_cursor.position
#	elif Input.is_action_just_released("ui_down"):
#		if insideMatrix(m_cursor.position + Vector2(0,1)):
#			moveCursorTo(m_cursor.position)
#	elif Input.is_action_just_released("ui_up"):
#		if insideMatrix(m_cursor.position + Vector2(0,-1)):
#			moveCursorTo(m_cursor.position)
#	elif Input.is_action_just_released("ui_right"):
#		if insideMatrix(m_cursor.position + Vector2(1,0)):
#			moveCursorTo(m_cursor.position)
#	elif Input.is_action_just_released("ui_left"):
#		if insideMatrix(m_cursor.position + Vector2(-1,0)):
#			moveCursorTo(m_cursor.position)
#	return null
#
#func moveCursorTo(var position):
#	m_cursor.position = position
#	m_cursor.mesh.set_translate(m_map.getObjectPosition(position))
#
#func isCaseOverlayed(var position):
#	if m_map.m_matrix[position.x][position.y].overlay:
#		return true
#	return false
#
#func disableSelection():
#	m_cursor.set_visible(false)
#	disableAllOverlayCases()
#
#func disableAllOverlayCases():
#	var matrix = m_map.matrix
#	for i in range(matrix.size()):
#		for j in range(matrix.size()) :
#			matrix.overlay.queue_free()
#
#func addOverlay(var position):
#	m_map.m_matrix[position.x][position.y].overlay = instanceOverlay(position)
#
#func insideMatrix(var position):
#	if position.x >= m_map.m_matrix.size() || position.x < 0 || position.y >= m_map.m_matrix[position.x].size() || position.y < 0:
#		return false
#	return true
#
## a completer au fur et a mesure des types de case
##du moins à modifier et faire en fct des catégories
#func isfreeCase(var position):
#	if m_map.m_matrix[position.x][position.y].selectable == null:
#		return true
#	return false
#
#func addSelectable(var selectable, var position):
#	m_map.m_matrix[position.x][position.y].selectable = selectable
#
##move the selectable to the new position . BE CAREFUL : don't move the graphics selectable
#func moveSelectable(var position, var toPosition):
#	# don't check if the final position is busy by something or not
#	if !freeCase(position):
#		m_map.m_matrix[toPosition.x][toPosition.y].selectable = m_map.m_matrix[position.x][position.y].selectable
#		m_map.m_matrix[toPosition.x][toPosition.y].selectable.set_position(toPosition)
#		clearCase(m_map.m_matrix[position.x][position.y])
#		return true
#	return false
#
#func getObjectPosition(var position):
#	var sizeElement = getSizeElement()
#	return position * sizeElement
#
#func _ready():
#	add_child(m_cursorMesh)
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