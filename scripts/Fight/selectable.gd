extends Node

var caracteristics

var menu

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
	self.menu = Tools.MENU_SCENE.instance()
	self.menu.connect("choose_action_signal", game, "on_choose_action")
	game.get_node("HUD").add_child(self.menu)
	
func init_menu(var game):
	for action_name in game.current_playing_character().action_names:
		var action = Tools.actions_dico.get_action(action_name)
		if action.type != 4:
			if self.is_in_group("Characters"):
				if self == game.current_playing_character():
					if action.type == 0:
						self.menu.add(action, game, self)
				elif self.same_side(game.current_playing_character()):
					if action.type == 2 && action.range_cond.call_func(game, self):
						self.menu.add(action, game, self)
				else:
					if action.type == 1 && action.range_cond.call_func(game, self):
						self.menu.add(action, game, self)
			#if object
			else:
				pass
	self.menu.hide()
	self.menu.set_position($animation.position)

func open_menu():
	if Tools.current_menu:
		Tools.current_menu.hide()
	Tools.current_menu = self.menu
	self.menu.show()
	
func close_menu():
	self.menu.clear()
		
func _ready():
	$animation.connect("animation_finished", self, "on_animation_finished")
	$animation/Area2D.connect("input_event", self, "on_selectable_event")
	set_process(false)
	
func on_selectable_event(var viewport, var event, var shape_idx):
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == BUTTON_LEFT:
			open_menu()