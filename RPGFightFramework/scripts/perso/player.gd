extends "res://RPGFightFramework/scripts/perso/characterPerso.gd"

var m_menu
var m_menuFightClass

func init(var name, var position, var actionNames, var category, var tileSize, var pathsToTextures, var life, var attackPourcentage, var defensePoucentage, var nbStepsBase, var state, var scene, var menuFightClassPath):
	.init(name, position, actionNames, category, tileSize, pathsToTextures, life, attackPourcentage, defensePoucentage, nbStepsBase, state, scene)
	m_menuFightClass = load(menuFightClassPath)

# @function : initMenu
# @description : Initialise un menu graphique à partie des actions liées au personnage
# @params :
# 	scene : l'objet scene de combat
# 	actionsDico : dictionnaire d'actions disponibles
func initMenu(var scene, var actionsDico, var viewportSize):
	if m_actionNames == null:
		print("Error : impossible de créer le menu, Character non initialisé")
	else:
		m_menu = m_menuFightClass.new()
		m_menu.init(actionsDico, m_actionNames, viewportSize)
		m_menu.set_visible(false)
		scene.add_child(m_menu)
		
func getMenu():
	return m_menu