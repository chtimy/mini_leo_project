extends "res://scripts/Fight/character.gd"

const MENU_ACTION_SCENE = preload("res://scenes/Fight/menuActionsFight.tscn")

var menu

func _init(var name, var groups, var caracteristics, var position, var action_names, var opp_attack_names, var graphics, var map, var image).(name, groups, caracteristics, position, action_names, opp_attack_names, graphics, map, image):
	pass

func _ready():
	self.menu = MENU_ACTION_SCENE.instance()
	self.menu.init(actions_dico, m_action_names)
	add_child(self.menu)
	self.menu.set_visible(false)