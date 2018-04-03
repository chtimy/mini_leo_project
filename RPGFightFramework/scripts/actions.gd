extends Node

var m_actions = {
	}
var m_toolFunctions = {
	}

func init(var ReaderScript):
	var descrActions = ReaderScript.readActionsFile()
	if descrActions != null:
		collectActions(descrActions)
		return true
	return false
	
func collectActions(var descrActions):
	for descrAction in descrActions.values():
		var s = descrAction.name + "Action"
		var s2 = descrAction.name + "Range"
		m_actions[descrAction.name] = {name = descrAction.name, 
									   id = descrAction.id, 
									   pathToTextures = descrAction.pathToTexture, 
									   type = descrAction.type,
									   target = descrAction.target, 
									   effects = descrAction.effects,
									   process = funcref(get_script(), s), 
									   rangeCond = funcref(get_script(), s2)}
	m_toolFunctions["is_something_there"] = funcref(get_script(), "is_something_there")
	m_toolFunctions["is_enemi_there"] = funcref(get_script(), "is_enemi_there")