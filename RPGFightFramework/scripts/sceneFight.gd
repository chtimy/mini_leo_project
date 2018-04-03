extends Node2D

var m_actions = { }
var m_selectables = []
var m_map

var ReaderScript = load("res://RPGFightFramework/scripts/reader.gd").new()

#during turn
enum {INIT_TURN, CHOOSE_MENU, TARGET, END_TURN}
var m_state = INIT_TURN
#order of turns
var m_turns = []
var m_currentMenuAttack
var m_currentAction
func _ready():
	set_process(true)

func init(var mapPathFile, var actionPathFile, var selectables):
	m_listActions = load(actionPathFile).new()
	if m_listActions.init(ReaderScript):
		m_selectables = selectables
		var tileSize = get_viewport().get_size().y * TILESIZE
		#map generation
		m_map = Node2D.new()
		m_map.set_script(load("res://RPGFightFramework/scripts/fightMap.gd"))
		m_map.init("res://data/fightScene/mapFight01.txt" , Vector2(tileSize, tileSize), "res://images/map/fightScene/overlay.png", "res://images/map/fightScene/cursor.png", ReaderScript)
		if m_map != null:
			var i = 0
			var j = 0
			for c in characters:
				var pos
				var character = Node2D.new()
				character.set_script(load("res://RPGFightFramework/scripts/character.gd"))
				if c.category == "Players":
					pos = m_map.m_initialPositions[0][i]
					j += 1
				elif c.category == "Enemis":
					pos = m_map.m_initialPositions[1][i]
					i += 1
				character.init(get_node("."), c.name, c.category, c.texturePaths, c.life, c.attackPourcentage, c.defensePourcentage, c.actionNames, c.nbStepsBase, pos, c.state, tileSize, m_listActions)
				m_characters.append(character)
			m_currentMenuAttack = m_characters[0].m_menu
			m_objects = objects
			add_child(m_map)
			#init turns
			m_turns.push_back(0)
			m_turns.push_back(1)

#Destruction de la zone de combat
func destroy():
	m_characters = []
	m_objects = []

func _process(delta):
	var turn = m_turns.front()
	if m_characters[turn].m_category == "Players":
		#Players turn
		if playerTurn(turn):
			m_turns.push_back(m_turns.pop_front())
	elif m_characters[turn].m_category == "Enemis":
		#Enemis turn (IA)
		if enemiTurn(turn):
			m_turns.push_back(m_turns.pop_front())

#gestion du tour du joueur
func playerTurn(var turn):
	if m_state == INIT_TURN:
		m_currentMenuAttack = m_characters[turn].m_menu
		m_currentMenuAttack.set_visible(true)
		m_state = CHOOSE_MENU
	elif m_state == CHOOSE_MENU:
		#si menu retourne action
		var actionName =  m_currentMenuAttack.getAction()
		if actionName != null :
			#exec action
			m_currentAction = m_listActions.m_actions[actionName]
			m_map.activeCases(m_currentAction.rangeCond, m_listActions.m_toolFunctions, m_characters, turn, m_objects)
			if(m_currentAction.type == 0 || m_currentAction.type == 1):
				m_map.setCurrentPositionCursor(m_characters[turn].m_position)
				m_state = TARGET
			else:
				#m_currentAction.process.call_func()
				m_state = END_TURN
			#hide currentMenu 
			m_currentMenuAttack.reinit()
			m_currentMenuAttack.set_visible(false)
	elif m_state == TARGET:
		var pos = m_map.chooseTile()
		if pos != null:
			if m_currentAction.type == 0:
				m_currentAction.process.call_func(m_characters[turn], pos)
			elif m_currentAction.type == 1:
				m_currentAction.process.call_func(m_characters[turn], get_target_character(pos))
			m_state = END_TURN
	elif m_state == END_TURN:
		m_map.disableSelection()
		#if pas mort alors on met le tour derriere
		m_state = INIT_TURN

func enemiTurn(var turn):
	pass

func get_target_character(var position):
	for character in m_characters:
		if character.m_position == position:
			return character
	return null