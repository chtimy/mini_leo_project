extends Viewport

func changeMap(var map):
	if get_children().size() > 0:
		remove_child(self.get_children()[0])
	self.add_child(map)