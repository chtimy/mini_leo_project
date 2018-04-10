extends "res://RPGFightFramework/scripts/selectable.gd"

var m_tileSize
# Category of the character, for example : Players, Enemis, Objects, PNG, ...
var m_category
var m_actionNames
var m_texturePaths
var m_graphics

func init(var name, var position, var actionNames, var category, var tileSize, var pathsToTextures):
	.init(name, position)
	m_tileSize = tileSize
	m_actionNames = actionNames
	m_texturePaths = pathsToTextures
	m_category = category

func isCategory(var category):
	if m_category == category:
		return true
	return false
