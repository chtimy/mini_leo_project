extends "res://RPGFightFramework/scripts/map.gd"

var m_overlayScene

func _init(var map).(map):
	pass
	
func getSizeElement():
	return m_map.m_sizeElement
	
#abstract functions : 
#func getObjectPosition(var position):
#	pass
	
#move the selectable to the new position . BE CAREFUL : don't move the graphics selectable
#func moveSelectable(var position, var toPosition):
#	pass
#
#func addSelectable(var selectable, var position):
#	pass
	
func setOverlayMesh(var overlayScene):
	m_overlayScene = overlayScene

func setCursorMesh(var cursorScene):
	m_cursor.mesh = cursorScene.instance()
	m_cursor.mesh.set_visible(false)
	m_cursor.mesh.set_name("cursor")

func setCursorVisible(var boolean):
	m_cursor.mesh.set_visible(boolean)

func instanceOverlay():
	return m_overlayScene.instance()

#abstract function
#	abstract func activeOverlays(var rangeCond, var toolFunctions, var characters, var currentCharacterIndex, var objects)
