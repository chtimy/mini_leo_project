extends Node

var caracteristics

var menu = Tools.MENU_SCENE.instance()

func _init(var name, var groups = [], caracteristics = []):
	set_name(name)
	self.caracteristics = caracteristics
	for group in groups:
		add_to_group(group)
		
func get_caracteristic(var name):
	return self.caracteristics[name]

func set_caracteristic(var name, var value):
	self.caracteristics[name] = value
	emit_signal("change_caracteristic_from_characterPerso", {"name" : name, "value" : self.caracteristics[name]})
	
func add_caracteristic(name, value):
	self.caracteristics[name].append(value)
	emit_signal("change_caracteristic_from_characterPerso", {"name" : name, "value" : self.caracteristics[name]})
	
func create_menu(var game):
	for action_name in game.current_playing_character().action_names:
		var action = Tools.actions_dico.get_action(action_name)
#		if self == game.current_character_playing():
		if action.type == 1 && action.range_cond.call_func(game, self):
			self.menu.add(action, game, self)
	menu.hide()
	add_child(menu)

func open_menu():
	if Tools.current_menu:
		Tools.current_menu.hide()
	Tools.current_menu = self.menu
	self.menu.show()
		
func _ready():
	$animation.connect("animation_finished", self, "on_animation_finished")
	$animation/Area2D.connect("input_event", self, "on_selectable_event")
	set_process(false)
	
func on_selectable_event(var viewport, var event, var shape_idx):
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == BUTTON_LEFT:
			open_menu()