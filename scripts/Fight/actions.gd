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
		var s = descrAction.name + "Action"
		var s2 = descrAction.name + "Conditions"
		var s3 = descrAction.name + "RangeConditions"
		var s4 = descrAction.name + "GetInfo"
		m_actions[descrAction.name] = {name = descrAction.name, 
									   id = descrAction.id, 
									   pathToTextures = descrAction.pathToTexture, 
									   type = descrAction.type,
									   target = descrAction.target, 
									   effects = descrAction.effects,
#									   cond = funcref(get_script(), s2),
									   getInfo = funcref(get_script(), s4),
									   play = funcref(get_script(), s), 
									   rangeCond = funcref(get_script(), s3)}
	
func getAction(var name):
	return m_actions[name]