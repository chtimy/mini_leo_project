extends PopupMenu

var m_mapLayout
var m_subMenuGroup

var m_groupNames = []

enum {CHOOSE_BY_PLAYER = 0, SELECTABLE = 2, ADD_CONDITION_LEVEL = 1}

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
	
func buildSubMenuGroup(var cellIndex):
	m_subMenuGroup.clear()
	for groupName in m_groupNames:
		m_subMenuGroup.add_item(groupName)
	m_subMenuGroup.add_item("new...")
		
func addGroupName(var name):
	if m_groupNames.find(name) == -1:
		m_groupNames.append(name)

func _on_PopupMenu_index_pressed(index):
	var map = m_mapLayout.m_map
	var indexCell = map.positionToIndex(map.getIntersectionPoint(m_mapLayout.m_lastClickPositionInMap))
	var tree = m_mapLayout.get_node("VBoxContainer/Tree")
	match index:
		CHOOSE_BY_PLAYER:
			tree.addSelectedCellsCaracteristic("chooseByPlayer")
		ADD_CONDITION_LEVEL:
#			tree.addSelectedCellsButton("Condition level 1", "res://images/symboles/eye2.png")
			map.addCellCaracteristic(indexCell, "conditionOtherLevel")
			var node = tree.searchChildInTree(tree.get_root(), 0, String(indexCell))
			if node:
				var carac = tree.create_item(node)
				carac.add_button(1, load("res://images/symboles/eye2.png"))
				carac.set_text(0, "Condition level 1")
				var mapLayout = load("res://RPGFightFramework/scenes/modeleur/map_layout.tscn").instance()
				mapLayout.init(self)
				map.addLevel(indexCell, mapLayout)
	m_mapLayout.set_process_input(true)
	
func _on_popupSubMenu_index_pressed(var index):
	var map = m_mapLayout.m_map
	var tree = m_mapLayout.get_node("VBoxContainer/Tree")
	var nbNewItem = m_subMenuGroup.get_item_count() - 1
	var indexCell = map.positionToIndex(map.getIntersectionPoint(m_mapLayout.m_lastClickPositionInMap))
	match index:
		nbNewItem:
			var askForNamePopup = m_mapLayout.get_node("AskForNameSelectPopUpable")
			askForNamePopup.set_position(get_viewport().get_mouse_position())
			askForNamePopup.show()
			
			yield(askForNamePopup,"confirmed")
			
			var node = tree.searchChildInTree(tree.get_root(), 0, String(indexCell))
			var group = tree.searchChildInTree(node, 0, "group")
			if !group:
				group = tree.create_item(node)
				group.set_text(0, "group")
			var item = tree.create_item(group)
			var groupName = askForNamePopup.get_node("VBoxContainer/LineEdit").get_text()
			askForNamePopup.get_node("VBoxContainer/LineEdit").clear()
			addGroupName(groupName)
			item.set_text(0, groupName)
		_:
			tree.addCellCaracteristic(indexCell, get_item_text(index))
	m_mapLayout.set_process_input(true)