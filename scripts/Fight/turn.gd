extends Control

var state = INIT_TURN
#order of turns
var turns = []
var characters
var current_menu_attack
var current_action
var actions_dico
var map
var objects
var values = {}

#during turn
enum {INIT_TURN, CHOOSE_MENU, PLAY, END_TURN}

func _ready():
	set_process(true)
	
func init(var characters, var objects, var actions_dico, var map):
	self.actions_dico = actions_dico
	self.characters = characters
	self.map = map
	self.objects = objects
	for i in range(characters.size()):
		self.turns.push_back(i)
	
func _process(delta):
	var turn = get_current_turn()
	if self.characters[turn].is_in_group("Players"):
		#Players turn
		if player_turn(turn):
			next_turn()
	elif self.characters[turn].is_in_group("Enemis"):
		#Enemis turn (IA)
		if enemi_turn(turn):
			next_turn()
			
# @function : playerTurn
# @description : Gestion du tour du joueur
# @params :
#	turn : Numéro de tour courant
func player_turn(var turn):
	if self.state == INIT_TURN:
		self.current_menu_attack = self.characters[turn].menu
		self.current_menu_attack.enable(true)
		self.current_menu_attack.test_actions(self, self.actions_dico)
		self.state = CHOOSE_MENU
	elif self.state == CHOOSE_MENU:
		#si menu retourne action
		var action_name =  self.current_menu_attack.get_action()
		if action_name != null :
			self.current_action = self.actions_dico.get_action(action_name)
			if self.current_action.range_cond.call_func(self, true):
				self.state = PLAY
			#hide currentMenu 
			self.current_menu_attack.enable(false)
	elif self.state == PLAY:
		self.current_action.play.call_func(self)
	elif self.state == END_TURN:
		#if pas mort alors on met le tour derriere
		self.state = INIT_TURN
		return true
	return false

func end_turn():
	self.state = END_TURN
	set_process(true)
	
# @function enemiTurn
# @description : Gestion du tour de l'ennemi
# @params :
# 	turn : tour courant
func enemi_turn(var turn):
	return true
	
func current_playing_character():
	return self.characters[get_current_turn()]
func get_map():
	return self.map
func get_current_turn():
	return self.turns.front()
func next_turn():
	self.turns.push_back(self.turns.pop_front())
# @function : getTargetCharacter
# @description : Recherche quel personnage correspond à la position en entrée
# @params :
# 	position : position recherchée
func get_target_character(var position):
	for character in self.characters:
		if character.m_position == position:
			return character
	return null
		
func save_value(var key, var value):
	self.values[key] = value
func get_value(var key):
	return self.values[key]
func load_value(var key):
	var value = self.values[key]
	self.values[key] = null
	return value
func has_value(var key):
	return self.values.has(key)
func clear_values():
	self.values.clear()