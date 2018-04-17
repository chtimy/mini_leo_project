extends Node

#Map[][]{
#	int value
#	Sprite tileSprite
#	Sprite overlaySprite
#	bool overlay
#}

var m_initialPositions
var m_cursor
var m_currentPositionCursor

func init():
	pass

func setCurrentPositionCursor(var position):
	m_currentPositionCursor = position