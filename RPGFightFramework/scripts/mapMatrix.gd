extends "res://RPGFightFramework/scripts/map.gd"

var m_overlayCells
var m_sizeCell
var m_origin

var m_initialPositionsCharacters
var m_initialPositionsEnemis

func getNextPlayerInitPosition():
	return m_initialPositionsCharacters.pop_front()

func getNextEnemiInitPosition():
	return m_initialPositionsEnemis.pop_front()

func _init().():
	pass
	
func getSizeCell():
	return m_sizeCell
	
#abstract functions : 
#func getObjectPosition(var position):
#	pass
	
#move the selectable to the new position . BE CAREFUL : don't move the graphics selectable
#func moveSelectable(var position, var toPosition):
#	pass
#
#func addSelectable(var selectable, var position):
#	pass
	
#func setOverlayMesh(var overlayScene):
#	m_overlayScene = overlayScene

func setCursorMesh(var cursorScene):
	m_cursor.mesh = cursorScene.instance()
	m_cursor.mesh.set_visible(false)
	m_cursor.mesh.set_name("cursor")

func setCursorVisible(var boolean):
	m_cursor.mesh.set_visible(boolean)

func addInstanceOverlay():
	var nbInstances = m_overlayCells.get_multimesh().get_instance_count()
	m_overlayCells.get_multimesh().set_instance_count(nbInstances+1)
	return nbInstances
	
func setTransformOverlayMeshInstance(var indexInstance, var transform):
#	print(m_overlayCells.get_multimesh().get_instance_count())
#	print(indexInstance)
	m_overlayCells.get_multimesh().set_instance_transform(indexInstance, transform)

func setColorOverlayMeshInstance(var indexInstance, var color):
	m_overlayCells.get_multimesh().set_instance_color(indexInstance, color)
	
func getOverlay(var index):
	m_overlayCells.get_multimesh().get_instance()[index]

func removeLastInstanceOverlay():
	var nbInstances = m_overlayCells.get_multimesh().get_instance_count()
	m_overlayCells.get_multimesh().set_instance_count(nbInstances-1)

#abstract function
#	abstract func activeOverlays(var rangeCond, var toolFunctions, var characters, var currentCharacterIndex, var objects)
