extends "res://scripts/Fight/mapMatrix3D.gd"

########################################################################################################################################
###################################################		SIGNALS	########################################################################
########################################################################################################################################
signal overlay_clicked_from_map

########################################################################################################################################
###################################################		MEMBERS	########################################################################
########################################################################################################################################
export (float) var ZOOM_FACTOR = 0.1
export (PackedScene) var OVERLAY_SCENE
var m_lastClickPositionInMap
var m_camera
var m_plan
enum {SELECTION_MODE = 1}
var mode = SELECTION_MODE

var lastClickedCell = null

########################################################################################################################################
###################################################		METHODS	########################################################################
########################################################################################################################################
func _init().(Vector3(20, 5, 20), Vector3(-10,0,-10)):
	m_size_cell = Vector3(1,1,1)
	self.matrix = []
	for i in range(dimensions.x):
		self.matrix.append([])
		for j in range(dimensions.y):
			self.matrix[i].append([])
			for k in range(dimensions.z):
				self.matrix[i][j].append([])
				self.matrix[i][j][k] = {}
	
func _ready():
	m_camera = Camera.new()
	m_camera.set_environment(get_node("environment").get_environment())
	m_camera.look_at_from_position(Vector3(12,18,12), Vector3(2.5,0,2.5), Vector3(0,1,0))
	add_child(m_camera)
	
	var mesh_instance = get_node("MeshInstance")
	mesh_instance.set_scale(Vector3(dimensions.x + m_size_cell.x, 1, dimensions.z + m_size_cell.z))
	
	m_overlay_cells = MultiMeshInstance.new()
	m_overlay_cells.set_name("Overlays")
	var multimesh = MultiMesh.new()
	multimesh.set_color_format(MultiMesh.COLOR_FLOAT)
	multimesh.set_mesh(OVERLAY_SCENE.instance().get_mesh())
	#A report : Bug de chez Godot ?? Si on met à la main dans l'instanciation de la scène çà ne marche pas
	multimesh.set_transform_format(MultiMesh.TRANSFORM_3D)
	multimesh.set_instance_count(dimensions.x * dimensions.z)
	var material = SpatialMaterial.new()
	m_overlay_cells.set_multimesh(multimesh)
	m_overlay_cells.set_material_override(material)
	material.set_flag(SpatialMaterial.FLAG_ALBEDO_FROM_VERTEX_COLOR, true)
	for i in range(dimensions.x * dimensions.z):
		var t = Transform(Basis(), Vector3(-1000, -1000, -1000))
		m_overlay_cells.get_multimesh().set_instance_transform(i, t)
		m_overlay_cells.get_multimesh().set_instance_color(i, Color(0, 1, 1))
	add_child(m_overlay_cells)
	
	m_plan = Plane(Vector3(0,1,0), 0)
	
	set_process(true)
	
func _process(delta):
	control_camera()
	
func _input(event):
	match self.mode:
		SELECTION_MODE:
			if event is InputEventMouseMotion :
				var position = get_intersection_point(get_mouse_position())
				if position.x >= origin.x && position.z >= origin.z:
					var index = position_to_index(position)
					if is_overlay_cell_at_index(index):
						if lastClickedCell != null:
							set_color_overlay_mesh_instance(lastClickedCell, Color(0.0,0.5,0.5))
						set_color_overlay_mesh_instance(index, Color(1.0,0.0,0.0))
						lastClickedCell = index
					elif lastClickedCell != null:
						set_color_overlay_mesh_instance(lastClickedCell, Color(0.0,0.5,0.5))
						lastClickedCell = null
			if event is InputEventMouseButton :
				if event.get_button_index() == BUTTON_LEFT && event.pressed == false:
					if lastClickedCell != null:
						print("click on ", lastClickedCell)
						emit_signal("overlay_clicked_from_map", lastClickedCell)
						#disable_selection()
func add_overlay_selection(var index):
	if is_inside_matrix_bounds(index):
		if add_overlay_cell_by_index(index):
			return 1
		return 0
	return -1
			
func save_overlay_selection():
	remove_all_overlay_cells()
	
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
	
func get_intersection_point(var mouse_position):
	return m_plan.intersects_ray(m_camera.project_ray_origin(mouse_position), m_camera.project_ray_normal(mouse_position)) 
	
func get_mouse_position():
	return get_viewport().get_mouse_position()

func select_overlay(var vec):
	set_color_overlay_mesh_instance(vec, Color(1, 0, 0))
	
func deselect_overlay(var vec):
	set_color_overlay_mesh_instance(vec, Color(0, 1, 1))
	
func to_2D_plan(var camera):
	camera.look_at_from_position(Vector3(0,20,0), Vector3(0, 0, 0), Vector3(0,0,1))
func to_3D_plan(var camera):
	camera.look_at_from_position(Vector3(12,12,12), Vector3(2.5,0,2.5), Vector3(0,1,0))

func _on_OptionButton_item_selected(ID):
	print(ID)
	if ID == 1:
		to_2D_plan(m_camera)
	if ID == 0:
		to_3D_plan(m_camera)
