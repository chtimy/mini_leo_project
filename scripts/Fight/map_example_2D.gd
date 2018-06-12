extends "res://scripts/Fight/mapMatrix2D.gd"

########################################################################################################################################
###################################################		SIGNALS	########################################################################
########################################################################################################################################
signal overlay_clicked_from_map
signal move_from_map

########################################################################################################################################
###################################################		MEMBERS	########################################################################
########################################################################################################################################
export (float) var ZOOM_FACTOR = 0.1
export (PackedScene) var OVERLAY_SCENE
var m_lastClickPositionInMap
var m_camera
var m_plan
enum {NO_MODE = 0, SELECTION_MODE = 1, DRAW_ARROW = 2}
var mode = NO_MODE

var lastClickedCell = null
var path = {
	"cond" : null,
	"last_solution" : null
}

var arrow_origin

########################################################################################################################################
###################################################		METHODS	########################################################################
########################################################################################################################################

##################################### NODE #############################################
func _init().(Vector2(15, 15), Vector2(0, 0), Vector2(128,128)):
	self.matrix = []
	for i in range(dimensions.x):
		self.matrix.append([])
		for j in range(dimensions.y):
				self.matrix[i].append([])
				self.matrix[i][j] = {}
	
func _ready():
	m_camera = Camera2D.new()
	m_camera.set_position(Vector2(12,12))
	add_child(m_camera)
	
	overlay_scene = OVERLAY_SCENE
	
	set_process(true)
	
func _process(delta):
	control_camera()
	
##################################### INPUTS #############################################
func _input(event):
	if self.mode == SELECTION_MODE || self.mode == DRAW_ARROW:
		if event is InputEventMouseMotion :
			var position = get_mouse_position()
			if position.x >= origin.x && position.y >= origin.y:
				var index = position_to_index(position)
				if is_overlay_cell_at_index(index):
					if lastClickedCell != null:
						set_color_overlay_mesh_instance(lastClickedCell, Color("cceef283"))
					set_color_overlay_mesh_instance(index, Color(1.0,0.0,0.0,0.5))
					if self.mode == DRAW_ARROW:
						$draw_space.show()
						self.path.last_solution = Tools.shortest_path(self.arrow_origin, index, self, [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)], self.path.cond)
						$draw_space.mode = $draw_space.DRAW_ARROW
						$draw_space.path = self.path.last_solution
						$draw_space.update()
					lastClickedCell = index
				elif lastClickedCell != null:
					set_color_overlay_mesh_instance(lastClickedCell, Color("cceef283"))
					lastClickedCell = null
		if event is InputEventMouseButton :
			if event.get_button_index() == BUTTON_LEFT && event.pressed == false:
				if lastClickedCell != null:
					print("click on ", lastClickedCell)
					if self.mode == DRAW_ARROW:
						set_mode(SELECTION_MODE)
						$draw_space.hide()
						emit_signal("move_from_map", self.path.last_solution)
					else:
						emit_signal("overlay_clicked_from_map", lastClickedCell)

func set_mode(var mode, var args = []):
	self.mode = mode
	if mode == DRAW_ARROW:
		self.arrow_origin = args[0]
		self.path.cond = args[1]
		
##################################### OVERLAYS #############################################
func add_overlay_selection(var index):
	if is_inside_matrix_bounds(index):
		if add_overlay_cell_by_index(index):
			return 1
		return 0
	return -1
			
func save_overlay_selection():
	remove_all_overlay_cells()
	
func select_overlay(var vec):
	set_color_overlay_mesh_instance(vec, Color(1, 0, 0))
	
func deselect_overlay(var vec):
	set_color_overlay_mesh_instance(vec, Color(0, 1, 1))
	
##################################### CAMERA #############################################
#TODO : a gérer mieu que çà surtout pour la 2D
func control_camera():
	if Input.is_action_just_released("ui_control_camera_zoom_up"):
		var dir = -m_camera.get_translation().normalized() * ZOOM_FACTOR
#		var up = m_camera.get_camera_transform().
		m_camera.look_at_from_position(m_camera.get_translation() + dir, Vector3(2.5,0,2.5), Vector3(0,1,0))
		return true
	elif Input.is_action_just_released("ui_control_camera_zoom_down"):
		var dir = m_camera.get_translation().normalized() * ZOOM_FACTOR
		m_camera.look_at_from_position(m_camera.get_translation() + dir, Vector3(2.5,0,2.5), Vector3(0,1,0))
		return true
	return false
	
func to_2D_plan(var camera):
	camera.look_at_from_position(Vector3(0,20,0), Vector3(0, 0, 0), Vector3(1,0,0))
func to_3D_plan(var camera):
	camera.look_at_from_position(Vector3(12,12,12), Vector3(2.5,0,2.5), Vector3(0,1,0))
	
func _on_OptionButton_item_selected(ID):
	print(ID)
	if ID == 1:
		to_2D_plan(m_camera)
	if ID == 0:
		to_3D_plan(m_camera)
	
##################################### MAP #############################################
func get_intersection_point(var mouse_position):
	return get_mouse_position()
	
func get_mouse_position():
	return get_viewport().get_mouse_position()
	
##################################### SELECTABLES #############################################	
func neighbor(var position, var neighbouring, var white_list):
	var selectables = []
	for neighbour in neighbouring:
		var selectable = Tools.search_selectable_in_tab_by_group(get_selectables_from_cell(position + neighbour), "Characters")
		if selectable:
			var is_enemi = true
			for group in white_list:
				if selectable.is_in_group(group):
					is_enemi = false
			selectables.push_back(selectable)
	return selectables
	
func ask_around_possible_action(var character):
	var game = get_node("..")
	var position = character.position
	for v in [Vector3(1,0,0), Vector3(0,0,1), Vector3(-1,0,0), Vector3(0,0,-1)]:
		var selectable = get_selectable_from_matrix(position + v)
		if selectable && ((selectable.is_in_group("Enemis") && character.is_in_group("Players")) || (selectable.is_in_group("Player") && character.is_in_group("Enemis"))):
			selectable.do_opportunity_actions(game)