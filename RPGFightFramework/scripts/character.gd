extends "res://RPGFightFramework/scripts/selectable.gd"

# Category of the character, for example : Players, Enemis, Objects, PNG, ...
var m_category
var m_actionNames
var m_graphics

func _init(var name, var position, var actionNames, var category, var graphics).(name, position):
	m_graphics = graphics
	m_actionNames = actionNames
	m_category = category

func isCategory(var category):
	if m_category == category:
		return true
	return false
	
func _ready():
	self.add_child(m_graphics)
