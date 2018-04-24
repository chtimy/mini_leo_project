extends "res://RPGFightFramework/scripts/perso/characterPerso.gd"

var m_menu

func _init(var name, var position, var actionNames, var category, var caracteristics, var menuFightClassPath, var graphics).(name, position, actionNames, category, caracteristics, graphics):
	m_menu = load(menuFightClassPath)

func initMenu(actionsDico):
	m_menu = m_menu.new(actionsDico, m_actionNames)
	
func _ready():
	self.add_child(m_menu)
	m_menu.set_visible(false)
		
func getMenu():
	return m_menu