extends Node

var caracteristics

func _init(var name, var groups = [], caracteristics = []):
	set_name(name)
	self.caracteristics = caracteristics
	for group in groups:
		add_to_group(group)
		
func get_caracteristic(var name):
	return self.caracteristics[name]

func set_caracteristic(var name, var value):
	self.caracteristics[name] = value
	emit_signal("change_caracteristic_from_characterPerso", {"name" : name, "value" : self.caracteristics[name]})
	
func add_caracteristic(name, value):
	self.caracteristics[name].append(value)
	emit_signal("change_caracteristic_from_characterPerso", {"name" : name, "value" : self.caracteristics[name]})