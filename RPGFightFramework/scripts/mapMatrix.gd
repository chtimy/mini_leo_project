extends "res://RPGFightFramework/scripts/map.gd"

func _init(var map).(map):
	pass
#
#func activeCases(var rangeCond, var toolFunctions, var characters, var currentCharacterIndex, var objects):
#	for i in range(m_matrix.size()):
#		for j in range(m_matrix[i].size()):
#			if rangeCond.call_func(characters, currentCharacterIndex, objects, Vector2(i, j), toolFunctions):
#				m_mat[i][j].overlay = 1
#				enableOverlayCases(Vector2(i, j))
#
#func chooseTile():
#	m_cursor.set_visible(true)
#	if Input.is_action_just_released("ui_take"):
#		if isTileOk(m_currentPositionCursor):
#			return m_currentPositionCursor
#	elif Input.is_action_just_released("ui_down"):
#		if m_currentPositionCursor.y < m_matrix[m_currentPositionCursor.x].size()-1:
#			m_currentPositionCursor.y += 1
#	elif Input.is_action_just_released("ui_up"):
#		if m_currentPositionCursor.y > 0:
#			m_currentPositionCursor.y -= 1
#	elif Input.is_action_just_released("ui_right"):
#		if m_currentPositionCursor.x < m_matrix.size()-1:
#			m_currentPositionCursor.x += 1
#	elif Input.is_action_just_released("ui_left"):
#		if m_currentPositionCursor.x > 0:
#			m_currentPositionCursor.x -= 1
#	m_cursor.set_position(m_currentPositionCursor * m_tileSize)
#	return null
#
#func isTileOk(var position):
#	if m_mat[position.x][position.y]:
#		return true
#	return false
#
#func enableOverlayCases(var position):
#	if insideMatrix(position):
#		if freeCase(position):
#	 		m_matrix[position.x][position.y].overlaySprite.set_visible(true)
#
#func disableSelection():
#	m_cursor.set_visible(false)
#	disableAllOverlayCases()
#
#func disableAllOverlayCases():
#	for i in range(m_matOverlay.size()):
#		for j in range(m_matOverlay[i].size()) :
#			m_matOverlay[i][j] = 0
#			m_matrix[i][j].overlaySprite.set_visible(false)

func insideMatrix(var position):
	if position.x >= m_map.m_matrix.size() || position.x < 0 || position.y >= m_map.m_matrix[position.x].size() || position.y < 0:
		return false
	return true

# a completer au fur et a mesure des types de case
#du moins à modifier et faire en fct des catégories
func freeCase(var position):
	if m_map.m_matrix[position.x][position.y].value == 1:
		return true
	return false

#move the selectable to the new position . BE CAREFUL : don't move the graphics selectable
func moveSelectable(var position, var toPosition):
	# don't check if the final position is busy by something or not
	if !freeCase(position):
		m_map.m_matrix[toPosition.x][toPosition.y] = m_map.m_matrix[position.x][position.y]
		clearCase(m_map.m_matrix[position.x][position.y])
		return true
	return false

#func clearCase(var case):
#	case.value == 1

func addSelectable(var selectable, var position):
	m_map.m_matrix[position.x][position.y].selectable = selectable
	
func getSizeElement():
	return m_map.sizeElement