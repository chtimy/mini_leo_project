extends PopupMenu

########################################################################################################################################
###################################################		SIGNALS	########################################################################
########################################################################################################################################
signal addCaracteristic
signal addMapLevelDown
signal addGroup

########################################################################################################################################
###################################################		MEMBERS	########################################################################
########################################################################################################################################
var m_mapLayout
var m_subMenuGroup
var m_groupNames = []
enum {CHOOSE_BY_PLAYER = 0, SELECTABLE = 2, ADD_CONDITION_LEVEL = 1}

########################################################################################################################################
###################################################		METHODS	########################################################################
########################################################################################################################################
func _ready():
	m_mapLayout = get_node("..")
	add_item("Set as selection mode")
	add_item("Add condition other level")
	m_subMenuGroup = PopupMenu.new()
	m_subMenuGroup.set_name("Set condition group")
	m_subMenuGroup.add_item("new...")
	add_child(m_subMenuGroup)
	add_submenu_item("Set condition group...", "Set condition group")
	m_subMenuGroup.connect("index_pressed", self, "_on_popupSubMenu_index_pressed")
	connect("addCaracteristic", m_mapLayout, "on_addCaracteristic")
	connect("addMapLevelDown", m_mapLayout, "on_addMapLevelDown")
	connect("addGroup", m_mapLayout, "on_addGroup")
	
func buildSubMenuGroup(var cellIndex):
	m_subMenuGroup.clear()
	for groupName in m_groupNames:
		m_subMenuGroup.add_item(groupName)
	m_subMenuGroup.add_item("new...")
		
func addGroupName(var name):
	if m_groupNames.find(name) == -1:
		m_groupNames.append(name)
		

########################################################################################################################################
###################################################		SLOTS	########################################################################
########################################################################################################################################
func _on_PopupMenu_index_pressed(index):
	var map = m_mapLayout.m_map
	var indexCell = map.positionToIndex(map.getIntersectionPoint(map.m_lastClickPositionInMap))
	var tree = m_mapLayout.get_node("VBoxContainer/Tree")
	match index:
		CHOOSE_BY_PLAYER:
			emit_signal("addCaracteristic", "chooseByPlayer")
#			tree.addSelectedCellsCaracteristic("chooseByPlayer")
		ADD_CONDITION_LEVEL:
			var askForMapPopup = get_node("../AskForMapPopUp")
			askForMapPopup.set_position(get_viewport().get_mouse_position())
			askForMapPopup.init()
			askForMapPopup.show()
			yield(askForMapPopup, "confirmed")
			var indexMenu = askForMapPopup.m_index
			var nameMap = askForMapPopup.get_node("VBoxContainer/MenuButton").get_popup().get_item_text(indexMenu)
			emit_signal("addMapLevelDown", nameMap)
			
#			tree.addSelectedCellsButton("Condition level 1", "res://images/symboles/eye2.png")
#			map.addCellCaracteristic(indexCell, "conditionOtherLevel")
#			var node = tree.searchChildInTree(tree.get_root(), 0, String(indexCell))
#			if node:
#				var carac = tree.create_item(node)
#				carac.add_button(1, load("res://images/symboles/eye2.png"))
#				carac.set_text(0, "Condition level 1")
#				var mapLayout = load("res://RPGFightFramework/scenes/modeleur/map_layout.tscn").instance()
#				mapLayout.init(self)
#				map.addLevel(indexCell, mapLayout)
	m_mapLayout.set_process_input(true)
	
func _on_popupSubMenu_index_pressed(var index):
	var map = m_mapLayout.m_map
	var tree = m_mapLayout.get_node("VBoxContainer/Tree")
	var nbNewItem = m_subMenuGroup.get_item_count() - 1
	var indexCell = map.positionToIndex(map.getIntersectionPoint(map.m_lastClickPositionInMap))
	match index:
		nbNewItem:
			var askForNamePopup = m_mapLayout.get_node("AskForNameSelectPopUpable")
			askForNamePopup.set_position(get_viewport().get_mouse_position())
			askForNamePopup.show()
			yield(askForNamePopup,"confirmed")
			var lineEdit = askForNamePopup.get_node("VBoxContainer/LineEdit")
			emit_signal("addGroup", lineEdit.get_text())
			addGroupName(lineEdit.get_text())
			lineEdit.clear()
		_:
			emit_signal("addGroup", m_subMenuGroup.get_item_text(index))
	m_mapLayout.set_process_input(true)