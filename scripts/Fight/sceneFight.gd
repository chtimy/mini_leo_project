extends Node

var characters = []
var objects = []
var map
var selectables = []
var turn_handler
var actions_dico
var current_menu_attack
var current_action

var state = INIT_TURN
enum{INIT_TURN, CHOOSE_MENU, PLAY, END_TURN}
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
	self.turn_handler = $HUD/turn_counter
	var ACTIONS_CLASS = load("res://scripts/Fight/actionPerso.gd")
	if ACTIONS_CLASS:
		self.actions_dico = ACTIONS_CLASS.new()
		self.selectables = selectables
		
		#temp
		var initial_positions_enemis = [Vector2(2, 1), Vector2(4, 4)]
		var initial_positions_players = [Vector2(3,3), Vector2(4, 3), Vector2(2,3), Vector2(2, 2)]
		var index_player = 0
		var index_enemi = 0
		
		#Generation des selectables
		var position = null
		var i = 0
		for selectable in self.selectables:
			if selectable.is_in_group("Objects"):
				self.objects.append(selectable)
			else:
				selectable.actions_dico = actions_dico
				if selectable.is_in_group("Players"):
					position = initial_positions_players[index_player]
					index_player += 1
					i += 1
				else:
					position = initial_positions_enemis[index_enemi]
					index_enemi += 1
					i += 1
				self.map.add_selectable_to_cell(selectable, position)
				selectable.position_in_matrix = position
				selectable.set_graphics_position(position)
				self.characters.append(selectable)
				
				var caracteristics_menu = CARACTERISTIC_MENU_SCENE.instance()
				caracteristics_menu = CARACTERISTIC_MENU_SCENE.instance()
				caracteristics_menu.init(selectable, selectable.caracteristics)
				add_child(caracteristics_menu)
				self.turn_handler.add_character(selectable)
	else:
		print("Error : Impossible to load all the scripts")
		
	self.set_name("sceneFight")
	$CenterContainer.add_child(self.map)
	#Generation des selectables
	var i = 0
	var j = 0
	for selectable in self.selectables:
		#selectable.initMenu(get_node("."), m_actionsDico, viewportSize)
		add_child(selectable)

func _process(delta):
	var turn = self.turn_handler.get_current_turn()
	if self.characters[turn].is_in_group("Players"):
		#Players turn
		if player_turn(turn):
			$HUD/turn_counter.next_turn()
	elif self.characters[turn].is_in_group("Enemis"):
		#Enemis turn (IA)
		if enemi_turn(turn):
			$HUD/turn_counter.next_turn()
	
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
	return self.characters[turn_handler.get_current_turn()]
	
func drop_object_on_the_floor(var object, var position):
	self.map.add_selectable_to_cell(object, position)
	var selectables = map.get_selectables_from_cell(position)
	object.set_graphics_position(position)
	add_child(object)
	
func pick_object_from_the_floor(var position):
	var selectables = map.get_selectables_from_cell(position)
	var object = Tools.search_selectable_in_tab_by_group(selectables, "Objects")
	map.remove_selectable_from_cell(object, position)
	remove_child(object)
	return object