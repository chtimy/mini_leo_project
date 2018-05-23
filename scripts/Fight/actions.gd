const READER_CLASS = preload("res://scripts/Fight/reader.gd")


var m_actions = {
	}
var m_toolFunctions = {
	}

func _init():
	var descrActions = READER_CLASS.new().readActionsFile()
	if descrActions != null:
		collectActions(descrActions)
		return true
	return false
	
func collectActions(var descrActions):
	for descrAction in descrActions.values():
		var s = descrAction.name + "_action"
		var s2 = descrAction.name + "_conditions"
		var s3 = descrAction.name + "_range_conditions"
		var s4 = descrAction.name + "_get_info"
		m_actions[descrAction.name] = {"name" : descrAction.name, 
									   "id" : descrAction.id, 
									   "path_to_textures" : descrAction.pathToTexture, 
									   "type" : descrAction.type,
									   "target" : descrAction.target, 
									   "effects" : descrAction.effects,
#									   "cond" : funcref(get_script(), s2),
									   "getInfo" : funcref(get_script(), s4),
									   "play" : funcref(get_script(), s), 
									   "range_cond" : funcref(get_script(), s3)}
	
func get_action(var name):
	return m_actions[name]