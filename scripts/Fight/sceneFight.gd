extends Node

var m_actions_dico = { }
var m_characters = []
var m_objects = []
var m_map
var m_selectables = []
var m_tile_size
var m_turn_handler

# @function : init
# @Description : initialisation de la scène de combat 
# @params :
#	mapFilePath : Chemin vers un fichier map
#	selectables : tableau de selectionnables
func _init(var actions_file_path, var map, var turn_script_path, var selectables):
	var TURN_CLASS = load(turn_script_path)
	var ACTIONS_CLASS = load(actions_file_path)
	
	if TURN_CLASS and ACTIONS_CLASS:
		m_actions_dico = ACTIONS_CLASS.new()
		m_map = map
#		var overlay_scene = load("res://RPGFightFramework/scenes/perso/overlay.tscn")
#		m_map.set_overlay_mesh(overlay_scene)
#		var cursor_scene = load("res://RPGFightFramework/scenes/perso/cursor.tscn")
#		m_map.set_cursor_mesh(cursor_scene)
		m_selectables = selectables
		
		#temp
		var initial_positions_enemis = [Vector3(2, 0, 2), Vector3(3, 0, 4)]
		var initial_positions_players = [Vector3(0, 0, 0), Vector3(0, 0, 1)]
		var indexPlayer = 0
		var indexEnemi = 0
		
		
		#Generation des selectables
		var position = null
		for selectable in m_selectables:
			print(selectable.get_groups())
			if selectable.is_in_group("Objects"):
				m_objects.append(selectable)
			else:
				if selectable.is_in_group("Players"):
					selectable.init_menu(m_actions_dico)
					position = initial_positions_players[indexPlayer]
					indexPlayer += 1
				else:
					position = initial_positions_enemis[indexEnemi]
					indexEnemi += 1
				m_map.add_selectable_to_cell(selectable, position)
				selectable.set_position_in_matrix(position, m_map)
				m_characters.append(selectable)
		m_turn_handler = TURN_CLASS.new(m_characters, m_objects, m_actions_dico, m_map)
	else:
		print("Error : Impossible to load all the scripts")
	
func get_tile_size():
	return m_tile_size
func get_actions_dico():
	return m_actions_dico
	
func _ready():
	self.set_name("sceneFight")
	add_child(m_map)
	#Generation des selectables
	var i = 0
	var j = 0
	for selectable in m_selectables:
		#selectable.initMenu(get_node("."), m_actionsDico, viewportSize)
		add_child(selectable)

func _process(delta):
	m_turn_handler.play()