extends "res://RPGFightFramework/scripts/perso/characterPerso.gd"

var m_menu

func init(var name, var position, var actionNames, var category, var tileSize, var pathsToTextures, var life, var attackPourcentage, var defensePoucentage, var nbStepsBase, var state, var scene):
	.init(name, position, actionNames, category, tileSize, pathsToTextures, life, attackPourcentage, defensePoucentage, nbStepsBase, state, scene)

# @function : initMenu
# @description : Initialise un menu graphique à partie des actions liées au personnage
# @params :
# 	scene : l'objet scene de combat
# 	actionsDico : dictionnaire d'actions disponibles
func initMenu(var scene, var actionsDico, var viewportSize):
	if m_actionNames == null:
		print("Error : impossible de créer le menu, Character non initialisé")
	else:
		m_menu = load("res://RPGFightFramework/scenes/menuActionsFight.tscn").instance()
		m_menu.init(actionsDico, m_actionNames, viewportSize)
		m_menu.set_visible(false)
		scene.add_child(m_menu)
		
func getMenu():
	return m_menu