extends "res://RPGFightFramework/scripts/character.gd"

var m_menus

func init(var scene, var name, var category, var pathsToTextures, var life, var attackPourcentage, var defensePoucentage, var actionNames, var nbStepsBase, var position, var state, var tileSize, var actions):
	.init(scene, name, category, pathsToTextures, life, attackPourcentage, defensePourcentage, actionNames, nbStepsBase, position, state, tileSize, actions)
	initMenu(scene)
	
func initMenu(var scene):
	#init menu
	m_menu = load("res://RPGFightFramework/scenes/menuActionsFight.tscn").instance()
	scene.add_child(m_menu)
	m_menu.init(actions, m_actionNames)
	m_menu.set_visible(false)