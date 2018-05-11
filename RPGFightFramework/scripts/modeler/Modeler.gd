extends "res://RPGFightFramework/scripts/mapMatrix3D.gd"

########################################################################################################################################
###################################################		SIGNALS	########################################################################
########################################################################################################################################
signal clickRightMap
signal clickLeftCellMap

########################################################################################################################################
###################################################		MEMBERS	########################################################################
########################################################################################################################################
export (int) var HEIGHT = 20
export (int) var DEEP = 20
export (int) var WIDTH = 20
export (int) var ZOOM_FACTOR = 0.1
const TOOLS = preload("res://RPGFightFramework/scripts/modeler/tools.gd")
export (PackedScene) var PLAYER_SCENE
export (PackedScene) var OVERLAY_SCENE
var m_lastClickPositionInMap
var m_camera
var m_plan
export (Vector3) var m_orientationModeler = Vector3(1,0,0)
export (Vector3) var  m_originModeler = Vector3(WIDTH*0.5,0,DEEP*0.5)

########################################################################################################################################
###################################################		METHODS	########################################################################
########################################################################################################################################
func _init().():
	m_origin = Vector3(-WIDTH*0.5, 0, -DEEP*0.5)
	m_sizeCell = Vector3(1,1,1)
	m_matrix = []
	for i in range(WIDTH):
		m_matrix.append([])
		for j in range(HEIGHT):
			m_matrix[i].append([])
			for k in range(DEEP):
				m_matrix[i][j].append([])
				m_matrix[i][j][k] = {}
	m_initialPositionsCharacters = [Vector3(0, 0, 0), Vector3(0, 0, 1)]
	m_initialPositionsEnemis = [Vector3(2, 0, 2), Vector3(3, 0, 4)]
	
func _ready():
	m_camera = Camera.new()
	m_camera.set_environment(get_node("environment").get_environment())
	m_camera.look_at_from_position(Vector3(12,12,12), Vector3(2.5,0,2.5), Vector3(0,1,0))
	add_child(m_camera)
	
	var player = PLAYER_SCENE.instance()
	player.set_scale(Vector3(0.5,0.5,0.5))
	player.set_translation(Vector3(0, 0.5, 0))
	add_child(player)
	
	var meshInstance = get_node("MeshInstance")
	meshInstance.set_scale(Vector3(WIDTH, 1, HEIGHT))
	
	m_overlayCells = MultiMeshInstance.new()
	m_overlayCells.set_name("Overlays")
	var multimesh = MultiMesh.new()
	multimesh.set_color_format(MultiMesh.COLOR_FLOAT)
	multimesh.set_mesh(OVERLAY_SCENE.instance().get_mesh())
	#A report : Bug de chez Godot ?? Si on met à la main dans l'instanciation de la scène çà ne marche pas
	multimesh.set_transform_format(MultiMesh.TRANSFORM_3D)
	multimesh.set_instance_count(WIDTH * DEEP)
	var material = SpatialMaterial.new()
	m_overlayCells.set_multimesh(multimesh)
	m_overlayCells.set_material_override(material)
	material.set_flag(SpatialMaterial.FLAG_ALBEDO_FROM_VERTEX_COLOR, true)
	for i in range(WIDTH * DEEP):
		var t = Transform(Basis(), Vector3(-1000, -1000, -1000))
		m_overlayCells.get_multimesh().set_instance_transform(i, t)
		m_overlayCells.get_multimesh().set_instance_color(i, Color(0, 1, 1))
	add_child(m_overlayCells)
	
	m_plan = Plane(Vector3(0,1,0), 0)
	
	var mapLayout = TOOLS.searchParentNodeRecursive(self, "MapLayout")
	#signals
	mapLayout.connect("addCaracteristicSignal", self, "on_addCaracteristic")
	mapLayout.connect("addMapLevelDownSignal", self, "on_addMapLevelDown")
	mapLayout.connect("addGroupSignal", self, "on_addGroup")
	connect("clickRightMap", mapLayout, "on_clickRightMap")
	connect("clickLeftCellMap", mapLayout, "on_clickLeftCellMap")
	
	set_process(true)
	
func _process(delta):
	controlCamera()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == BUTTON_LEFT && event.pressed == false:
			var index = positionToIndex(getIntersectionPoint(getMousePosition())).abs()
			emit_signal("clickRightMap", index)
		elif event.get_button_index() == BUTTON_RIGHT && event.pressed== false:
			m_lastClickPositionInMap = getMousePosition()
			if isOverlayCellAtIndex(positionToIndex(getIntersectionPoint(m_lastClickPositionInMap))):
				emit_signal("clickLeftCellMap", positionToIndex(getIntersectionPoint(m_lastClickPositionInMap)))
				set_process_input(false)
	
func addOverlaySelection(var index):
	if isInsideMatrixBounds(index):
		if addOverlayCellByIndex(index):
#			m_listPositions.push_back(index)
			return 1
		return 0
	return -1
			
func saveOverlaySelection():
	removeAllOverlayCells()
	
#TODO : a gérer mieu que çà surtout pour la 2D
func controlCamera():
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
	
func getIntersectionPoint(var mousePosition):
	return m_plan.intersects_ray(m_camera.project_ray_origin(mousePosition), m_camera.project_ray_normal(mousePosition)) 
	
func getMousePosition():
	return get_viewport().get_mouse_position()
	
func getNextPlayerInitPosition():
	return m_initialPositionsCharacters.pop_front()

func getNextEnemiInitPosition():
	return m_initialPositionsEnemis.pop_front()

func selectOverlay(var vec):
	setColorOverlayMeshInstance(vec, Color(1, 0, 0))
	
func deselectOverlay(var vec):
	setColorOverlayMeshInstance(vec, Color(0, 1, 1))
	
func to2DPlan(var camera):
	camera.look_at_from_position(Vector3(0,20,0), Vector3(0, 0, 0), Vector3(0,0,1))
func to3DPlan(var camera):
	camera.look_at_from_position(Vector3(12,12,12), Vector3(2.5,0,2.5), Vector3(0,1,0))
	
########################################################################################################################################
###################################################		SLOTS	########################################################################
########################################################################################################################################
func on_addCaracteristic(var cellIndex, var carac):
	var cell = m_matrix[cellIndex.x][cellIndex.y][cellIndex.z]
	if !cell.has("modeler"):
		cell["modeler"] = {}
	if !cell["modeler"].has("carac"):
		cell["modeler"]["carac"] = []
	cell["modeler"]["carac"].append(carac)
	
func on_addMapLevelDown(var cellIndex, var map):
	var cell = m_matrix[cellIndex.x][cellIndex.y][cellIndex.z]
	if !cell.has("modeler"):
		cell["modeler"] = {}
	cell["modeler"]["levelDown"] = map
	
func on_addGroup(var cellIndex, var group):
	var cell = m_matrix[cellIndex.x][cellIndex.y][cellIndex.z]
	if !cell.has("modeler"):
		cell["modeler"] = {}
	if !cell["modeler"].has("group"):
		cell["modeler"]["group"] = []
	cell["modeler"]["group"].append(group)

func _on_OptionButton_item_selected(ID):
	print(ID)
	if ID == 1:
		to2DPlan(m_camera)
	if ID == 0:
		to3DPlan(m_camera)
