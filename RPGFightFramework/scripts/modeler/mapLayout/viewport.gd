extends Viewport

########################################################################################################################################
###################################################		METHODS	########################################################################
########################################################################################################################################

func _ready():
	get_tree().get_root().connect("size_changed", self, "on_size_changed")

func changeMap(var map):
	if get_children().size() > 0:
		var child = self.get_children()[0]
		child.set_process(false)
		child.set_process_input(false)
		remove_child(child)
	self.add_child(map)

func _on_ViewportContainer_mouse_entered():
	if get_children().size() > 0:
		get_children()[0].set_process(true)
		get_children()[0].set_process_input(true)

func _on_ViewportContainer_mouse_exited():
	if get_children().size() > 0:
		get_children()[0].set_process(false)
		get_children()[0].set_process_input(false)
		
func on_size_changed():
	var viewportSize = get_tree().get_root().get_size()
	set_size(viewportSize * 0.7)
	get_parent().set_size(viewportSize * 0.7)