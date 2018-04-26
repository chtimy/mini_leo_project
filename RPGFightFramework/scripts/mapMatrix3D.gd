extends "res://RPGFightFramework/scripts/mapMatrix.gd"

func _init(var map).(map):
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
	var matrix = m_map.m_matrix
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			for k in range(matrix[i][j].size()):
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
	
func isCaseOverlayed(var position):
	if m_map.m_matrix[position.x][position.y][position.z].has("overlay") && m_map.m_matrix[position.x][position.y][position.z].overlay:
		return true
	return false

func moveCursorTo(var position):
	m_cursor.position = position
	m_cursor.mesh.set_translation(getObjectPosition(position) - Vector3(0,0.35,0))

func disableSelection():
	setCursorVisible(false)
	disableAllOverlayCases()

func disableAllOverlayCases():
	var matrix = m_map.m_matrix
	for i in range(matrix.size()):
		for j in range(matrix[i].size()) :
			for k in range(matrix[i][j].size()):
				if matrix[i][j][k].has("overlay") and matrix[i][j][k].overlay:
					matrix[i][j][k].overlay.queue_free()
					matrix[i][j][k].overlay = null
			
func addOverlay(var position):
	var overlay = instanceOverlay()
	# ATTENTION ici à l'offset de déplacement
	overlay.set_translation(getObjectPosition(position) - Vector3(0,0.4,0))
	m_map.m_matrix[position.x][position.y][position.z].overlay = overlay
	add_child(overlay)

func insideMatrix(var position):
	if position.x >= m_map.m_matrix.size() || position.x < 0 || position.y >= m_map.m_matrix[position.x].size() || position.y < 0|| position.z >= m_map.m_matrix[position.x][position.y].size() || position.z < 0:
		return false
	return true

# a completer au fur et a mesure des types de case
#du moins à modifier et faire en fct des catégories
func isfreeCase(var position):
	if !m_map.m_matrix[position.x][position.y][position.z].has("selectable") || m_map.m_matrix[position.x][position.y][position.z].selectable == null:
		return true
	return false

func setSelectable(var selectable, var position):
	m_map.m_matrix[position.x][position.y][position.z].selectable = selectable
	
#move the selectable to the new position . BE CAREFUL : don't move the graphics selectable
func moveSelectable(var position, var toPosition):
	# don't check if the final position is busy by something or not
	if !isfreeCase(position):
		m_map.m_matrix[toPosition.x][toPosition.y][toPosition.z].selectable = m_map.m_matrix[position.x][position.y][position.z].selectable
		clearCase(position)
		return true
	return false
	
func clearCase(var position):
	m_map.m_matrix[position.x][position.y][position.z].selectable = null
	
func getSelectable(var position):
	if isfreeCase(position):
		return null
	return m_map.m_matrix[position.x][position.y][position.z].selectable
	
func getObjectPosition(var position):
	var sizeElement = getSizeElement()
	var y = position.y
	while(insideMatrix(Vector3(position.x, y, position.z)) and m_map.m_matrix[position.x][y][position.z].type != 0):
		y+=1
	y-=position.y
	# ATTENTION : ici 0.75...
	return position * sizeElement + Vector3(0, sizeElement*y*0.75,0)
	
func on_surface(position):
	if ( position.y == 0 and m_map.m_matrix[position.x][position.y][position.z].type == 0 ) or ( insideMatrix(Vector3(position.x, position.y+1, position.z)) and m_map.m_matrix[position.x][position.y+1][position.z].type == 0 && m_map.m_matrix[position.x][position.y][position.z].type != 0 ) :
		return true
	return false

func _ready():
#	add_child(m_cursor.mesh)
	add_child(m_map)
#	#cursor to choose the tile
#	m_cursor = Sprite.new()
#	m_cursor.set_texture(load(mapDescr.cursorTexturePath))
#	m_cursor.set_scale(m_tileSize/m_cursor.get_texture().get_size().x)
#	m_cursor.set_centered(false)
#	m_cursor.set_position(Vector2(0, 0))
#	m_cursor.set_visible(false)
#	m_cursor.set_z_index(3)
#	add_child(m_cursor)