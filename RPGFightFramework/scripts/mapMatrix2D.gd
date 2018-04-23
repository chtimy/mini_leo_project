extends "res://RPGFightFramework/scripts/mapMatrix.gd"

func _init(var map).(map):
	pass
	#cursor to choose the tile
#	m_cursor = Sprite.new()
#	m_cursor.set_texture(load(mapDescr.cursorTexturePath))
	
#move the selectable to the new position . BE CAREFUL : don't move the graphics selectable
func moveSelectable(var selectable, var toPosition):
	if .moveSelectable(selectable.get_position(), toPosition):
		m_map.m_matrix[toPosition.x][toPosition.y].set_position(toPosition)
		return true
	return false

func addSelectable(var selectable, var position):
	.addSelectable(selectable, position)
	
func _ready():
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