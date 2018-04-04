extends Node2D

const RIGHT = 0
const LEFT = 1
const TILESIZE = 0.1

var m_listActions = { }
var m_characters = []
var m_objects = []
var m_menusAttack = []
var m_map
var m_selectables = []

var ReaderScript = load("res://RPGFightFramework/scripts/reader.gd").new()

#during turn
enum {INIT_TURN, CHOOSE_MENU, TARGET, END_TURN}
var m_state = INIT_TURN
#order of turns
var m_turns = []
var m_currentMenuAttack
var m_currentAction

func _ready():
	m_listActions = load("res://RPGFightFramework/scripts/actions.gd").new()
	if m_listActions.init(ReaderScript):
		#base de test : ( a supprimer )
		var characters = []
		var character = {
			name = "leo",
			life = 5,
			actionNames = ["cross", "posterize", "deplacer"],
			nbStepsBase = 3,
			category = "Players",
			texturePaths = ["res://images/map/fightScene/character.png"],
			attackPourcentage = 20,
			defensePourcentage = 20,
			state = "normal"
		}
		var ennemi = {
			name = "ennemi",
			life = 2,
			actionNames = ["cross"],
			nbStepsBase = 2,
			category = "Enemis",
			texturePaths = ["res://images/map/fightScene/ennemi.png"],
			attackPourcentage = 30,
			defensePourcentage = 30,
			state = "normal"
		}
		characters.append(character)
		characters.append(ennemi)
		var objects = []
		var selectables = []
		selectables.append(character)
		selectables.append(objects)
		
		#init turns
		m_turns.push_back(0)
		m_turns.push_back(1)
		
		init("res://data/fightScene/mapFight01.txt", selectables)
		#fin base de test
		set_process(true)

# initialisation de la scène de combat 
# matrix : map de la scène de combat
# characters : personnages et ennemis dans la zone de combat
# objects : objets dans la zone de combat
func init(var mapFilePath, var selectables):
	var tileSize = get_viewport().get_size().y * TILESIZE
	#map generation
	m_map = Node2D.new()
	m_map.set_script(load("res://RPGFightFramework/scripts/fightMap.gd"))
	m_map.init(mapFilePath , Vector2(tileSize, tileSize), ReaderScript)
	if m_map != null:
		var i = 0
		var j = 0
		for selectable in selectables:
			var pos
			var character = Node2D.new()
			character.set_script(load("res://RPGFightFramework/scripts/character.gd"))
			if selectable.category == "Players":
				pos = m_map.m_initialPositions[0][i]
				j += 1
			elif selectable.category == "Enemis":
				pos = m_map.m_initialPositions[1][i]
				i += 1
			character.init(get_node("."), c.name, c.category, c.texturePaths, c.life, c.attackPourcentage, c.defensePourcentage, c.actionNames, c.nbStepsBase, pos, c.state, tileSize, m_listActions)
			m_characters.append(character)
		m_currentMenuAttack = m_characters[0].m_menu
		m_objects = objects
		add_child(m_map)

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