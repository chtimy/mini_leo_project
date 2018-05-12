extends Object

var m_state = INIT_TURN
#order of turns
var m_turns = []
var m_characters
var m_current_menu_attack
var m_current_action
var m_actions_dico
var m_map
var m_objects

var m_values = {}


#during turn
enum {INIT_TURN, CHOOSE_MENU, GET_INFO, END_TURN}

func _init(var characters, var objects, var actions_dico, var map):
	m_actions_dico = actions_dico
	m_characters = characters
	m_map = map
	m_objects = objects
	for i in range(characters.size()):
		m_turns.push_back(i)
	
func play():
	var turn = get_current_turn()
	if m_characters[turn].is_in_group("Players"):
		#Players turn
		if player_turn(turn):
			next_turn()
	elif m_characters[turn].is_in_group("Enemis"):
		#Enemis turn (IA)
		if enemi_turn(turn):
			next_turn()
			
# @function : playerTurn
# @description : Gestion du tour du joueur
# @params :
#	turn : Numéro de tour courant
func player_turn(var turn):
	if m_state == INIT_TURN:
		m_current_menu_attack = m_characters[turn].menu
		m_current_menu_attack.enable(true)
		m_current_menu_attack.test_actions(self, m_actions_dico)
		m_state = CHOOSE_MENU
	elif m_state == CHOOSE_MENU:
		#si menu retourne action
		var action_name =  m_current_menu_attack.get_action()
		if action_name != null :
			m_current_action = m_actions_dico.get_action(action_name)
			if m_current_action.range_cond.call_func(self, true):
				m_state = GET_INFO
			#hide currentMenu 
			m_current_menu_attack.enable(false)
	elif m_state == GET_INFO:
		if m_current_action.getInfo.call_func(self):
			m_current_action.play.call_func(self)
			m_state = END_TURN
	elif m_state == END_TURN:
		#if pas mort alors on met le tour derriere
		m_state = INIT_TURN
		return true
	return false

# @function enemiTurn
# @description : Gestion du tour de l'ennemi
# @params :
# 	turn : tour courant
func enemi_turn(var turn):
	return true
	
func current_playing_character():
	return m_characters[get_current_turn()]
func get_map():
	return m_map
func get_current_turn():
	return m_turns.front()
func next_turn():
	m_turns.push_back(m_turns.pop_front())
# @function : getTargetCharacter
# @description : Recherche quel personnage correspond à la position en entrée
# @params :
# 	position : position recherchée
func get_target_character(var position):
	for character in m_characters:
		if character.m_position == position:
			return character
	return null
	
func save_value(var key, var value):
	m_values[key] = value
func get_value(var key):
	return m_values[key]
func load_value(var key):
	var value = m_values[key]
	m_values[key] = null
	return value
func has_value(var key):
	return m_values.has(key)
func clear_values():
	m_values.clear()