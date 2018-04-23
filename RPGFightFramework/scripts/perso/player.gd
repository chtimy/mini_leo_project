extends "res://RPGFightFramework/scripts/perso/characterPerso.gd"

var m_menu

func _init(var name, var position, var actionNames, var category, var life, var caracteristics, var state, var menuFightClassPath, var graphics).(name, position, actionNames, category, life, caracteristics, state, graphics):
	m_menu = load(menuFightClassPath)

func initMenu(actionsDico):
	m_menu = m_menu.new(actionsDico, m_actionNames)
	pass
	
func _ready():
	self.add_child(m_menu)
	m_menu.set_visible(false)
		
func getMenu():
	print(m_menu)
	return m_menu