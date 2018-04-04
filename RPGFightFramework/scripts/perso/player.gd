extends "res://RPGFightFramework/scripts/characterPerso.gd"

var m_menus

func init(var name, var position, var actionNames, var category, var tileSize, var pathsToTextures, var life, var attackPourcentage, var defensePoucentage, var nbStepsBase, var state, var scene):
	.init(name, position, actionNames, category, tileSize, pathsToTextures, life, attackPourcentage, defensePoucentage, nbStepsBase, state, scene)
	initMenu(scene)
	
func initMenu(var scene):
	#init menu
	m_menu = load("res://RPGFightFramework/scenes/menuActionsFight.tscn").instance()
	scene.add_child(m_menu)
	m_menu.init(actions, m_actionNames)
	m_menu.set_visible(false)
