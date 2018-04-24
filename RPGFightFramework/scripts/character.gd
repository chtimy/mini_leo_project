extends "res://RPGFightFramework/scripts/selectable.gd"

var m_actionNames
var m_graphics

func _init(var name, var position, var actionNames, var category, var graphics).(name, position, category):
	m_graphics = graphics
	m_actionNames = actionNames
	
func setPosition(var position, var map):
	.setPosition(position)
	m_graphics.set_translation(map.getObjectPosition(position))
	
func setRotation(var angle):
	var angleInRadians = angle * 2 * PI / 360.0
	m_graphics.rotate_y(angleInRadians)

func _ready():
	self.add_child(m_graphics)
