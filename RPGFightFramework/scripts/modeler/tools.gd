static func stringToVector3(var string):
	var vec = Vector3(-1,-1,-1)
	var regex = RegEx.new()
	regex.compile("(?<digit>[0-9]+)")
	var results = regex.search_all(string)
	if results.size() == 3:
		for i in range(3):
			vec[i] = results[i].get_string("digit").to_int()
		return vec
	return null
	
static func isVector3(var string):
	var regex = RegEx.new()
	regex.compile("([0-9]+, [0-9]+, [0-9]+)")
	if regex.search(string):
		return true
	return false
	
static func searchParentNodeRecursive(var node, var name):
	var parent = node
	while parent.get_parent() != node.get_tree().get_root() && parent.get_name() != name:
		parent = parent.get_parent()
	return parent