extends Node

var characters = []
var objects = []
var map
var selectables = []
var turn_handler
var actions_dico

var values = {}
var current_menu_attack
var current_action

var state = INIT_TURN
#order of turns
var turns = []
enum{INIT_TURN, CHOOSE_MENU, PLAY, END_TURN}

var TURN_SCENE = preload("res://scenes/Fight/turn.tscn")
const CARACTERISTIC_MENU_SCENE = preload("res://scenes/Fight/caracteristicsMenu.tscn")
export (Script) var INPUT_SCRIPT

# @function : init
# @Description : initialisation de la scène de combat 
# @params :
#	mapFilePath : Chemin vers un fichier map
#	selectables : tableau de selectionnables
func _ready():
	var input = INPUT_SCRIPT.new()
	self.selectables = input.selectables
	self.map = input.map
	var ACTIONS_CLASS = load("res://scripts/Fight/actionPerso.gd")
	if ACTIONS_CLASS:
		self.actions_dico = ACTIONS_CLASS.new()
		self.map = map
		self.selectables = selectables
		
		#temp
		var initial_positions_enemis = [Vector3(10, 0, 10), Vector3(11, 0, 11)]
		var initial_positions_players = [Vector3(11, 0, 10), Vector3(10, 0, 9)]
		var index_player = 0
		var index_enemi = 0
		
		#Generation des selectables
		var position = null
		var i = 0
		for selectable in self.selectables:
			selectable.actions_dico = actions_dico
			if selectable.is_in_group("Objects"):
				self.objects.append(selectable)
			else:
				if selectable.is_in_group("Players"):
					position = initial_positions_players[index_player]
					self.turns.push_back(i)
					index_player += 1
					i += 1
				else:
					position = initial_positions_enemis[index_enemi]
					index_enemi += 1
					self.turns.push_back(i)
					i += 1
				self.map.add_selectable_to_cell(selectable, position)
				selectable.set_position(position, self.map)
				self.characters.append(selectable)
				
				var caracteristicsMenu = CARACTERISTIC_MENU_SCENE.instance()
				caracteristicsMenu = CARACTERISTIC_MENU_SCENE.instance()
				caracteristicsMenu.init(selectable, selectable.caracteristics)
				add_child(caracteristicsMenu)
	
		self.turn_handler = TURN_SCENE.instance()
	else:
		print("Error : Impossible to load all the scripts")
		
		
	self.set_name("sceneFight")
	add_child(self.map)
	#Generation des selectables
	var i = 0
	var j = 0
	for selectable in self.selectables:
		#selectable.initMenu(get_node("."), m_actionsDico, viewportSize)
		add_child(selectable)
	add_child(self.turn_handler)
	self.turn_handler.set_process(true)

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

func get_current_turn():
	return self.turns.front()
	
func next_turn():
	self.turns.push_back(self.turns.pop_front())
	
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