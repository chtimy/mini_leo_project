extends Node

var m_position
var m_name

# Category of the character, for example : Players, Enemis, Objects, PNG, ...
var m_category

func _init(var name, var position, var category):
	m_name = name
	set_name(name)
	m_position = position
	m_category = category
	
func setPosition(var position):
	m_position = position
	
func isCategory(var category):
	if m_category == category:
		return true
	return false
	
func category():
	return m_category