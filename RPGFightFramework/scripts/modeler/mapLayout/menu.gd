extends MenuButton

const MAP_SCENE = preload("res://RPGFightFramework/scenes/modeleur/map_modeler.tscn")

signal newMapSignal
signal saveMapSignal

enum {SAVE_MAP_MENU = 1, NEW_MAP_MENU = 0}

func _ready():
	var popup = get_popup()
	popup.add_item("New map...")
	popup.add_item("Save map...")
	popup.connect("id_pressed", self, "on_id_pressed")

func on_id_pressed(var id):
	match id:
		SAVE_MAP_MENU:
			emit_signal("saveMapSignal") #saveOverlaySelection()
		NEW_MAP_MENU:
			var map = MAP_SCENE.instance()
			emit_signal("newMapSignal", map)