extends Control

var m_last_position

func _ready():
	self.set_position(get_viewport().get_size() * Vector2(0.8, 0.3))
	
func init(var selectable, var list_caracteristics):
	var grid_container = get_node("ScrollContainer/GridContainer")
	var title = get_node("title")
	title.set_text(selectable.get_name())
	for caracteristic in list_caracteristics.keys():
		var label = Label.new()
		label.set_name(caracteristic)
		label.set_text(caracteristic + " : ")
		grid_container.add_child(label)
		label = Label.new()
		label.set_text(String(list_caracteristics[caracteristic]))
		grid_container.add_child(label)
		
	print(selectable.get_node("animation"))
	
	selectable.connect("change_caracteristic_from_characterPerso", self, "on_change_caracteristic")
	selectable.get_node("animation").get_node("Area2D").connect("mouse_entered", self, "on_mouse_entered_character")
	selectable.get_node("animation").get_node("Area2D").connect("mouse_exited", self, "on_mouse_exited_character")
	
	self.set_visible(false)
	
func on_change_caracteristic(var carac):
	var children = get_node("ScrollContainer/GridContainer").get_children()
	for i in range(get_node("ScrollContainer/GridContainer").get_child_count()):
		if children[i].get_name() == carac.name:
			children[i+1].set_text(String(carac.value))
			
func on_mouse_entered_character():
	self.set_position(get_viewport().get_mouse_position())
	self.set_visible(true)
	
func on_mouse_exited_character():
	self.set_visible(false)

func _gui_input(var ev):
	if Input.is_action_just_pressed("left_click"):
		m_last_position = get_viewport().get_mouse_position()
		accept_event ( )
	elif Input.is_action_pressed("left_click"):
		var vec = get_viewport().get_mouse_position() - m_last_position
		self.set_position(self.get_position() + vec)
		m_last_position = get_viewport().get_mouse_position()
		accept_event ( )
