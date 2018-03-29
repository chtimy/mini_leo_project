extends Node

var m_matrix

var STRAIGHT = 0
var DIAGONAL = 1
var ROUND = 2 


func init(var map, var tileSize, var overlayTexturePath):
	var i = 0
	var j = 0
	m_matrix = []
	#for case in m_matrix
	for i in range(map.matrix.size()):
		m_matrix.append([])
		for j in range(map.matrix[i].size()):
			m_matrix[i].append({ value = map.matrix[i][j], tile = Sprite.new(), overlay = Sprite.new() } )
			var tile = m_matrix[i][j].tile
			tile.set_texture(load(map.textures[map.matrix[i][j]]))
			tile.set_scale(tileSize/tile.get_texture().get_size())
			tile.set_position(Vector2(i,j) * tileSize)
			tile.set_centered(false)
			add_child(tile)
			var overlay = m_matrix[i][j].overlay
			overlay.set_texture(load(overlayTexturePath))
			overlay.set_scale(tileSize/tile.get_texture().get_size())
			overlay.set_position(Vector2(i,j) * tileSize)
			overlay.set_centered(false)
			overlay.set_visible(false)
			add_child(overlay)

func activeCases(var position, var direction, var rangeSize):
	if direction == STRAIGHT:
		for i in range(position.x - rangeSize, position.x + rangeSize):
			enableOverlayCases(i, position.y)
		for j in range(position.y - rangeSize, position.y + rangeSize):
			enableOverlayCases(position.x, j)
	elif direction == DIAGONAL:
		for i in range(position.x - rangeSize, position.x + rangeSize):
			for j in range(position.y - rangeSize, position.y + rangeSize):
				enableOverlayCases(i, j)
				i +=1
	#pas vraiment rond :o
	elif direction == ROUND:
		for i in range(position.x - rangeSize, position.x + rangeSize):
			for j in range(position.y - rangeSize, position.y + rangeSize):
				enableOverlayCases(i, j)

func enableOverlayCases(var position):
	if insideMatrix(position):
		if freeCase(position):
			m_matrix[position.x][position.y].overlay.set_visible(true)

func disableAllOverlayCases():
	for line in m_matrix:
		for c in line :
			c.overlay.set_visible(true)

func insideMatrix(var position):
	if position.x >= m_matrix.size() || position.x < 0 || position.y >= m_matrix[position.x].size() || position.y < 0:
		return false
	return true

# a completer au fur et a mesure des types de case
#du moins à modifier et faire en fct des catégories
func freeCase(var position):
	if m_matrix[position.x][position.y] == 1:
		return true
	return false