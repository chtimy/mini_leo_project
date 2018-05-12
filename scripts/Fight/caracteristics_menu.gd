extends Control

var m_lastPosition

func _ready():
	self.set_custom_minimum_size(get_viewport().get_size() * Vector2(0.1, 0.3))
	self.set_size(get_viewport().get_size() * Vector2(0.1, 0.3))
	self.set_position(get_viewport().get_size() * Vector2(0.8, 0.3))
	
func init(var selectable, var listCaracteristics):
	var gridContainer = get_node("ScrollContainer/GridContainer")
	var title = get_node("title")
	title.set_text(selectable.get_name())
	for caracteristic in listCaracteristics.keys():
		var label = Label.new()
		label.set_name(caracteristic)
		label.set_text(caracteristic + " : ")
		gridContainer.add_child(label)
		label = Label.new()
		label.set_text(String(listCaracteristics[caracteristic]))
		gridContainer.add_child(label)
	
	selectable.connect("changeCaracteristic", self, "onChangeCaracteristic")
	selectable.m_graphics.get_node("RigidBody").connect("mouse_entered", self, "onMouseEnteredCharacter")
	selectable.m_graphics.get_node("RigidBody").connect("mouse_exited", self, "onMouseExitedCharacter")
	
	self.set_visible(false)
	
func onChangeCaracteristic(var carac):
	var children = get_node("ScrollContainer/GridContainer").get_children()
	for i in range(get_node("ScrollContainer/GridContainer").get_child_count()):
		if children[i].get_name() == carac.name:
			children[i+1].set_text(String(carac.value))
			
func onMouseEnteredCharacter():
	self.set_position(get_viewport().get_mouse_position())
	self.set_visible(true)
	
func onMouseExitedCharacter():
	self.set_visible(false)

func _gui_input(var ev):
	if Input.is_action_just_pressed("left_click"):
		m_lastPosition = get_viewport().get_mouse_position()
		accept_event ( )
	elif Input.is_action_pressed("left_click"):
		var vec = get_viewport().get_mouse_position() - m_lastPosition
		self.set_position(self.get_position() + vec)
		m_lastPosition = get_viewport().get_mouse_position()
		accept_event ( )
