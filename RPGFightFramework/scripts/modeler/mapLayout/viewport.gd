extends Viewport

func changeMap(var map):
	if get_children().size() > 0:
		var child = self.get_children()[0]
		child.set_process(false)
		child.set_process_input(false)
		remove_child(child)
	self.add_child(map)
	
########################################################################################################################################
###################################################		SLOTS	########################################################################
########################################################################################################################################
func _on_ViewportContainer_mouse_entered():
	if get_children().size() > 0:
		self.get_children()[0].set_process(true)
		self.get_children()[0].set_process_input(true)

func _on_ViewportContainer_mouse_exited():
	if get_children().size() > 0:
		self.get_children()[0].set_process(false)
		self.get_children()[0].set_process_input(false)