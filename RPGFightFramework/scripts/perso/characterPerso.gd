extends "res://RPGFightFramework/scripts/character.gd"

var m_caracteristics
var m_state
var m_life

func _init(var name, var position, var actionNames, var category, var life, var caracteristics, var state, var graphics).(name, position, actionNames, category, graphics):
	m_life = life
	m_caracteristics = caracteristics
	m_state = "normal"
#
#func setPosition(var position):
#	.setPosition(position)
#	m_graphics.set_position(m_position * m_map.getSizeElement())

func applyEffect(var effect):
	print(m_name, " recoit ", effect)
	m_state = effect

func takeDamages(var nbPoints):
	print(m_name, " recoit ", nbPoints, " de dégats")
	m_life -= nbPoints