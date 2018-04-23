extends Node

var m_position
var m_name

func _init(var name, var position):
	m_name = name
	m_position = position
	
func setPosition(var position):
	m_position = position