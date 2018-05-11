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
	match index:
		CHOOSE_BY_PLAYER:
			emit_signal("addCaracteristic", "chooseByPlayer")
		ADD_CONDITION_LEVEL:
			var askForMapPopup = get_node("../AskForMapPopUp")
			askForMapPopup.set_position(get_viewport().get_mouse_position())
			askForMapPopup.init()
			askForMapPopup.show()
			yield(askForMapPopup, "confirmed")
			var indexMenu = askForMapPopup.m_index
			var nameMap = askForMapPopup.get_node("VBoxContainer/MenuButton").get_popup().get_item_text(indexMenu)
			emit_signal("addMapLevelDown", nameMap)
	m_mapLayout.set_process_input(true)
	
func _on_popupSubMenu_index_pressed(var index):
	var map = m_mapLayout.m_map
	var nbNewItem = m_subMenuGroup.get_item_count() - 1
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