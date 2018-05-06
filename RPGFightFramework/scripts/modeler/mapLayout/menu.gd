extends MenuButton

enum {SAVE_MAP_MENU = 1, NEW_MAP_MENU = 0}

func _ready():
	var popup = get_popup()
	popup.add_item("New map...")
	popup.add_item("Save map...")
	popup.connect("id_pressed", self, "on_id_pressed")

func on_id_pressed(var id):
	match id:
		SAVE_MAP_MENU:
			m_map.saveOverlaySelection()
		NEW_MAP_MENU:
			var map = MAP_SCENE.instance()
			get_node("VBoxContainer/HBoxContainer/LevelMapsScrollContainer/GridContainer").addMap(map)
			pass