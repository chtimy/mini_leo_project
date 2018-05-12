extends "res://scripts/Fight/characterPerso.gd"

var menu setget ,menu_get

func _init(var name, var position, var action_names, var category, var caracteristics, var menu_fight_class_path, var graphics).(name, position, action_names, category, caracteristics, graphics):
	self.menu = load(menu_fight_class_path)

func init_menu(var actions_dico):
	self.menu = self.menu.new(actions_dico, m_action_names)

func _ready():
	add_child(self.menu)
	self.menu.set_visible(false)

func menu_get():
	return menu