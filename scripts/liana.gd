extends Sprite

signal grapping_object

var actions = [ "GRAP" ]

func _ready():
	print("liana2 node : begin _ready function")		
	get_node("Area2D").connect("liana_get_action", self, "on_liana_get_action")
	print("liana2 node : end _ready function")		

func on_liana_get_action(action, object):
	print("liana2 node : begin on_liana_get_action function")		
	if action == "ui_take" && is_in_group("objects_in_environment"):
		emit_signal("grapping_object", get_node("."))
	print("liana2 node : end on_liana_get_action function")		
	