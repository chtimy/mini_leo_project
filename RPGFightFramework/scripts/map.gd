extends Node

var m_map
var m_cursor = {}

func _init(var map):
	m_map = map
	
func getNextPlayerInitPosition():
	return m_map.m_initialPositionsCharacters.pop_front()

func getNextEnemiInitPosition():
	return m_map.m_initialPositionsEnemis.pop_front()
	
func getMatrix():
	return m_map.m_matrix


#func setCurrentPositionCursor(var position):
#	m_currentPositionCursor = position