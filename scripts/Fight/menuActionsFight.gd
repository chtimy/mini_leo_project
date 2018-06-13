extends Control

signal choose_action_signal

const MENU_ATTACK_SIZE = Vector2(0.1, 0.2)
const MENU_ATTACK_POSITION = Vector2(0.1, 0.15)

#struct Button
#{
#	string name
#	textureButton button
#	int actionId
#}

enum {NORMAL_TEXTURE = 0, ACTIVE_TEXTURE = 1, DISABLED_TEXTURE = 2}

var buttons = []
var current_button = 0

#attention il y a redondance des informations #pour que ce soit plus clair
#listActions : liste d'actions dans le fichier texte d'actions (dictionnaire)
#actions : liste d'actions lié aux personnages (strings)
#func init(var actions_strings_character):
#	for action_string_character in actions_strings_character:
#		var action = Tools.actions_dico.m_actions[action_string_character]
#		#nouveau bouton pour l'action
#		var button = {
#			#nom de l'action
#			"name" : action.name,
#			#assignation des textures
#			"actionner" : add_item(action.path_to_textures),
#			#id de l'action
#			"action_id" : action.id
#		}
#		self.buttons.append(button)
		
func add(var action, var game, var selectable):
	#nouveau bouton pour l'action
	var button = {
		#nom de l'action
		"name" : action.name,
		#assignation des textures
		"actionner" : add_item(action.path_to_textures),
		#id de l'action
		"action_id" : action.id
	}
	self.buttons.append(button)
	button.actionner.texture_button.connect("gui_input", self, "on_button_event", [selectable, button.name])
	button.actionner.texture_button.connect("mouse_entered", self, "on_button_mouse_entered", [button])
	button.actionner.texture_button.connect("mouse_exited", self, "on_button_mouse_exited", [button])
	
	var viewport_size = get_viewport().get_size()
	var vbox = $ScrollContainer/VBoxContainer
	var size_menu = MENU_ATTACK_SIZE * viewport_size
	vbox.add_child(button.actionner.texture_button)
	#on essaye de scaler le bouton pour le case dans le layout à la bonne taille
	var scale_button = (size_menu.y * 0.2) / button.actionner.texture_button.texture_normal.get_size().y
	button.actionner.texture_button.set_custom_minimum_size(button.actionner.texture_button.texture_normal.get_size() * scale_button)
#	#utile??
#	button.actionner.texture_button.set_size(button.actionner.texture_button.texture_normal.get_size() * scale_button)
	
func on_button_event(ev, var selectable, var button):
	if ev is InputEventMouseButton && ev.pressed && ev.button_index == BUTTON_LEFT:
		emit_signal("choose_action_signal", button, selectable)
	
func on_button_mouse_entered(var button):
	set_active_button(button, ACTIVE_TEXTURE)
	
func on_button_mouse_exited(var button):
	set_active_button(button, NORMAL_TEXTURE)

func reinit():
	self.current_button = 0
	var i = 0
	for button in self.buttons:
		set_active_button(i, NORMAL_TEXTURE)
		self.buttons[i].state = NORMAL_TEXTURE
		i += 1
	set_active_button(0, ACTIVE_TEXTURE)
	
#Ajout d'un nouveau< TextureButton avec 
#pathTexture (texture normale) et 
#pathTexturePressed (texture press) en entrée
func add_item(var path_textures):
	var choice = {
		texture_button = TextureButton.new(),
		textures = [],
		state = NORMAL_TEXTURE
	}
	for path_texture in path_textures :
		choice.textures.append(load(path_texture))

	choice.texture_button.set_normal_texture(choice.textures[0])
	choice.texture_button.set_expand(true)
	return choice

# On gère le control du menu courant
#func get_action():
#	var action
#	if Input.is_action_just_released("ui_take"):
#		action = self.buttons[self.current_button].name
#	elif Input.is_action_just_released("ui_down"):
#		var i = 1
#		while self.current_button + i < self.buttons.size() && self.buttons[self.current_button + i].actionner.state == DISABLED_TEXTURE:
#			i += 1
#		if self.current_button + i < self.buttons.size():
#			var old_button = self.current_button
#			self.current_button = self.current_button + i
#			set_active_button(old_button, NORMAL_TEXTURE)
#			set_active_button(self.current_button, ACTIVE_TEXTURE)
#	elif Input.is_action_just_released("ui_up"):
#		var i = 1
#		while self.current_button - i >= 0 && self.buttons[self.current_button - i].actionner.state == DISABLED_TEXTURE:
#			i -= 1
#		if self.current_button - i >= 0:
#			var old_button = self.current_button
#			self.current_button = self.current_button - i
#			set_active_button(old_button, NORMAL_TEXTURE)
#			set_active_button(self.current_button, ACTIVE_TEXTURE)
#	return action
#
func set_active_button(var button, var index_texture):
	var actionner = button.actionner
	actionner.texture_button.set_normal_texture(actionner.textures[index_texture])
	actionner.state = index_texture

func enable(var boolean):
	set_visible(boolean)
	if !boolean:
		reinit()
		
func test_actions(var game, var dico_actions):
	for i in range(self.buttons.size()):
		if !dico_actions.get_action(self.buttons[i].name).range_cond.call_func(game, false):
			set_active_button(i, DISABLED_TEXTURE)
	var i = 0
	while self.current_button + i < self.buttons.size() && self.buttons[self.current_button + i].actionner.state == DISABLED_TEXTURE:
			i += 1
	if i < self.buttons.size():
		self.current_button = i
		set_active_button(self.current_button, ACTIVE_TEXTURE)
		return true
	return false

func clear():
	for button in self.buttons:
		button.actionner.texture_button.queue_free()
		var textures = button.actionner.textures
	buttons.clear()
	
func _ready():
	pass
#	var viewport_size = get_viewport().get_size()
#	set_position(MENU_ATTACK_POSITION * viewport_size)
#	var vbox = $ScrollContainer/VBoxContainer
#	var size_menu = MENU_ATTACK_SIZE * viewport_size
#	for button in self.buttons:
#		vbox.add_child(button.actionner.texture_button)
#		#on essaye de scaler le bouton pour le case dans le layout à la bonne taille
#		var scale_button = (size_menu.y * 0.2) / button.actionner.texture_button.texture_normal.get_size().y
#		button.actionner.texture_button.set_custom_minimum_size(button.actionner.texture_button.texture_normal.get_size() * scale_button)
#		#utile??
#		button.actionner.texture_button.set_size(button.actionner.texture_button.texture_normal.get_size() * scale_button)
	
	#if first option -> active the button
#	if self.buttons.size() > 0:
#		set_active_button(0, ACTIVE_TEXTURE)