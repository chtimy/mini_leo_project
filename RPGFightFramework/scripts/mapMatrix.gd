extends "res://RPGFightFramework/scripts/fightMap.gd"

var m_matrix
var m_matOverlay
var m_tileSize

func init(var mapName, var tileSize, var ReaderScript):
	.init()
	var mapDescr = ReaderScript.readMapFile(mapName)
	m_tileSize = tileSize
	var i = 0
	var j = 0
	m_initialPositions = mapDescr.initialPositions
	m_matrix = []
	m_matOverlay = []
	#for case in m_map
	for i in range(mapDescr.matrix.size()):
		m_matrix.append([])
		m_matOverlay.append([])
		for j in range(mapDescr.matrix[i].size()):
			m_matrix[i].append({ value = mapDescr.matrix[i][j], tileSprite = Sprite.new(), overlaySprite = Sprite.new(), overlay = 0 } )
			var tile = m_matrix[i][j].tileSprite
			var texture = load(mapDescr.textures[mapDescr.matrix[i][j]-1])
			if texture == null:
				print("Error : la texture n'a pas pu être chargée : \"", mapDescr.textures[mapDescr.matrix[i][j]-1],"\"")
			else:
				tile.set_texture(texture)
				tile.set_scale(m_tileSize/tile.get_texture().get_size())
				tile.set_centered(false)
			tile.set_position(Vector2(i,j) * m_tileSize)
			add_child(tile)
			var overlay = m_matrix[i][j].overlaySprite
			texture = load(mapDescr.overlayTexturePath)
			if texture == null:
				print("Error : la texture n'a pas pu être chargée : \"", mapDescr.overlayTexturePath, "\"")
			else:
				overlay.set_texture(texture)
				overlay.set_scale(m_tileSize/overlay.get_texture().get_size())
				overlay.set_centered(false)
			overlay.set_position(Vector2(i,j) * m_tileSize)
			overlay.set_visible(false)
			overlay.set_z_index(2)
			m_matOverlay[i].append(0)
			add_child(overlay)

	#cursor to choose the tile
	m_cursor = Sprite.new()
	m_cursor.set_texture(load(mapDescr.cursorTexturePath))
	m_cursor.set_scale(m_tileSize/m_cursor.get_texture().get_size().x)
	m_cursor.set_centered(false)
	m_cursor.set_position(Vector2(0, 0))
	m_cursor.set_visible(false)
	m_cursor.set_z_index(3)
	add_child(m_cursor)
	
func activeCases(var rangeCond, var toolFunctions, var characters, var currentCharacterIndex, var objects):
	for i in range(m_matrix.size()):
		for j in range(m_matrix[i].size()):
			print(rangeCond)
			if rangeCond.call_func(characters, currentCharacterIndex, objects, Vector2(i, j), toolFunctions):
				m_matOverlay[i][j] = 1
				enableOverlayCases(Vector2(i, j))

func chooseTile():
	m_cursor.set_visible(true)
	if Input.is_action_just_released("ui_take"):
		if isTileOk(m_currentPositionCursor):
			return m_currentPositionCursor
	elif Input.is_action_just_released("ui_down"):
		if m_currentPositionCursor.y < m_matrix[m_currentPositionCursor.x].size()-1:
			m_currentPositionCursor.y += 1
	elif Input.is_action_just_released("ui_up"):
		if m_currentPositionCursor.y > 0:
			m_currentPositionCursor.y -= 1
	elif Input.is_action_just_released("ui_right"):
		if m_currentPositionCursor.x < m_matrix.size()-1:
			m_currentPositionCursor.x += 1
	elif Input.is_action_just_released("ui_left"):
		if m_currentPositionCursor.x > 0:
			m_currentPositionCursor.x -= 1
	m_cursor.set_position(m_currentPositionCursor * m_tileSize)
	return null
	
func isTileOk(var position):
	if m_matOverlay[position.x][position.y]:
		return true
	return false

func enableOverlayCases(var position):
	if insideMatrix(position):
		if freeCase(position):
	 		m_matrix[position.x][position.y].overlaySprite.set_visible(true)

func disableSelection():
	m_cursor.set_visible(false)
	disableAllOverlayCases()

func disableAllOverlayCases():
	for i in range(m_matOverlay.size()):
		for j in range(m_matOverlay[i].size()) :
			m_matOverlay[i][j] = 0
			m_matrix[i][j].overlaySprite.set_visible(false)

func insideMatrix(var position):
	if position.x >= m_matrix.size() || position.x < 0 || position.y >= m_matrix[position.x].size() || position.y < 0:
		return false
	return true

# a completer au fur et a mesure des types de case
#du moins à modifier et faire en fct des catégories
func freeCase(var position):
	if m_matrix[position.x][position.y].value == 1:
		return true
	return false