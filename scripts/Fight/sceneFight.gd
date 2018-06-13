extends Node

signal choose_action_signal
signal end_turn_signal

var characters = []
var objects = []
var map
var selectables = []
var turn_handler
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
	map.connect("move_from_map_signal", self, "on_map_clicked_for_move")
	self.turn_handler = $HUD/turn_counter
	var ACTIONS_CLASS = load("res://scripts/Fight/actionPerso.gd")
	if ACTIONS_CLASS:
		Tools.actions_dico = ACTIONS_CLASS.new()
		self.selectables = selectables
		
		#temp
		var initial_positions_enemis = [Vector2(2, 1), Vector2(4, 4)]
		var initial_positions_players = [Vector2(3,3), Vector2(4, 3), Vector2(5,3), Vector2(2, 2)]
		var index_player = 0
		var index_enemi = 0
		
		#Generation des selectables
		var position = null
		var i = 0
		for selectable in self.selectables:
			if selectable.is_in_group("Objects"):
				self.objects.append(selectable)
			else:
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
				
				selectable.create_menu(self)
				
#				var caracteristics_menu = CARACTERISTIC_MENU_SCENE.instance()
#				caracteristics_menu = CARACTERISTIC_MENU_SCENE.instance()
#				caracteristics_menu.init(selectable, selectable.caracteristics)
#				add_child(caracteristics_menu)
				self.turn_handler.add_character(selectable)
	else:
		print("Error : Impossible to load all the scripts")
		
	self.set_name("sceneFight")
	add_child(self.map)
	#Generation des selectables
	var i = 0
	var j = 0
	for selectable in self.selectables:
		add_child(selectable)
	connect("end_turn_signal", self, "play_turn")
	set_process(true)
	
func _process(delta):
	print("process")
	play_turn()
	set_process(false)
		
func play_turn():
	print("new turn")
	var turn = self.turn_handler.get_current_turn()
	print("new turn with ", self.characters[turn])
	if self.characters[turn].is_in_group("Players"):
		#Players turn
		player_turn(turn)
	elif self.characters[turn].is_in_group("Enemis"):
		#Enemis turn (IA)
		enemi_turn(turn)
			
	
# @function : playerTurn
# @description : Gestion du tour du joueur
# @params :
#	turn : Numéro de tour courant
func player_turn(var turn):
	print("current : ", current_playing_character())
	#init menu of each character
	for selectable in selectables:
		selectable.init_menu(self)
	#init move zona on the map
	var action = Tools.actions_dico.get_action("deplacement")
	action.range_cond.call_func(self)
	var character = current_playing_character()
	if character.is_in_group("Enemis"):
		map.set_mode(map.DRAW_ARROW, [character.position_in_matrix, ["Players"]])
	else:
		map.set_mode(map.DRAW_ARROW, [character.position_in_matrix, ["Enemis"]])
	#wait for an action from the player
	var args = yield(self, "choose_action_signal")
	#close all menus and play the action
	for selectable in selectables:
		selectable.close_menu()
	self.current_action = Tools.actions_dico.get_action(args[0])
	self.current_action.play.call_func(self, args[1])
	#let the animations running till an signal emitted (call end_turn method)
	
func end_turn():
	#end of turn
	#pass to the next turn
	$HUD/turn_counter.next_turn()
	play_turn()
	
func on_choose_action(var action_name, var selectable):
	print(action_name, selectable)
	emit_signal("choose_action_signal", action_name, selectable)
	
func on_map_clicked_for_move(var path):
	map.disable_selection()
	var character = current_playing_character()
	character.path = path
	emit_signal("choose_action_signal", "deplacement", character)
	
# @function enemiTurn
# @description : Gestion du tour de l'ennemi
# @params :
# 	turn : tour courant
func enemi_turn(var turn):
	$HUD/turn_counter.next_turn()
	print("next turn : ", current_playing_character())
	set_process(true)
	print(is_processing())
	
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