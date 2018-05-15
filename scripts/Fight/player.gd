extends "res://scripts/Fight/character.gd"

var menu setget ,menu_get

func _init(var name, var groups, var caracteristics, var position, var action_names, var graphics, var menu_fight_class).(name, groups, caracteristics, position, action_names, graphics):
	self.menu = menu_fight_class.instance()

func init_menu(var actions_dico):
	print(m_action_names)
	self.menu.init(actions_dico, m_action_names)

func _ready():
	add_child(self.menu)
	self.menu.set_visible(false)

func menu_get():
	return menu