extends Object

var m_state = INIT_TURN
#order of turns
var m_turns = []
var m_characters
var m_currentMenuAttack
var m_currentAction
var m_actionsDico
var m_map
var m_objects

#during turn
enum {INIT_TURN, CHOOSE_MENU, TARGET, END_TURN}

func init(var characters, var objects, var actionsDico, var map):
	m_actionsDico = actionsDico
	m_characters = characters
	m_map = map
	m_objects = objects
	for i in range(characters.size()):
		m_turns.push_back(i)
	
func play():
	var turn = m_turns.front()
	if m_characters[turn].isCategory("Players"):
		#Players turn
		if playerTurn(turn):
			m_turns.push_back(m_turns.pop_front())
	elif m_characters[turn].isCategory("Enemis"):
		#Enemis turn (IA)
		if enemiTurn(turn):
			m_turns.push_back(m_turns.pop_front())
			
# @function : playerTurn
# @description : Gestion du tour du joueur
# @params :
#	turn : Numéro de tour courant
func playerTurn(var turn):
	if m_state == INIT_TURN:
		m_currentMenuAttack = m_characters[turn].getMenu()
		m_currentMenuAttack.enable(true)
		m_state = CHOOSE_MENU
	elif m_state == CHOOSE_MENU:
		#si menu retourne action
		var actionName =  m_currentMenuAttack.getAction()
		if actionName != null :
			#exec action
			m_currentAction = m_actionsDico.getAction(actionName)
			m_map.activeCases(m_currentAction.rangeCond, m_actionsDico.m_toolFunctions, m_characters, turn, m_objects)
			if(m_currentAction.type == 0 || m_currentAction.type == 1):
				m_map.setCurrentPositionCursor(m_characters[turn].m_position)
				m_state = TARGET
			else:
				#m_currentAction.process.call_func()
				m_state = END_TURN
			#hide currentMenu 
			m_currentMenuAttack.enable(false)
	elif m_state == TARGET:
		var pos = m_map.chooseTile()
		if pos != null:
			if m_currentAction.type == 0:
				m_currentAction.process.call_func(m_characters[turn], pos)
			elif m_currentAction.type == 1:
				m_currentAction.process.call_func(m_characters[turn], getTargetCharacter(pos))
			m_state = END_TURN
	elif m_state == END_TURN:
		m_map.disableSelection()
		#if pas mort alors on met le tour derriere
		m_state = INIT_TURN

# @function enemiTurn
# @description : Gestion du tour de l'ennemi
# @params :
# 	turn : tour courant
func enemiTurn(var turn):
	pass
	
# @function : getTargetCharacter
# @description : Recherche quel personnage correspond à la position en entrée
# @params :
# 	position : position recherchée
func getTargetCharacter(var position):
	for character in m_characters:
		if character.m_position == position:
			return character
	return null