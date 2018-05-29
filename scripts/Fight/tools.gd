extends Node

var values = {}

func throw_dice(var maxNumber):
	return randi() % maxNumber + 1
	
func draw_arrow(var geometry, var points, var map): 
	var size_cell_quarter = map.size_cell / 4
	var size_cell_half = map.size_cell / 2
	geometry.begin(Mesh.PRIMITIVE_TRIANGLES)
	for j in range(0, points.size()):
		var i = points.size() - j - 1
		if i == 0:
			var before_point = map.index_to_position(points[i + 1])
			before_point.y += 0.5
			var current_point = map.index_to_position(points[i])
			current_point.y += 0.5
			var direction_normalized = (current_point - before_point).normalized()
			var ortho = Vector3(-direction_normalized.z, direction_normalized.y, direction_normalized.x)
			var pt = current_point + ortho * size_cell_half - direction_normalized * size_cell_quarter
			geometry.set_normal(Vector3(0,1,0))
			geometry.add_vertex(pt)
			geometry.add_vertex(pt - ortho * map.size_cell)
			geometry.add_vertex(current_point)
		else:
			var before_point = map.index_to_position(points[i])
			before_point.y += 0.5
			var current_point = map.index_to_position(points[i - 1])
			current_point.y += 0.5
			var direction = current_point - before_point
			var direction_normalized = direction.normalized()
			var ortho = Vector3(-direction_normalized.z, direction_normalized.y, direction_normalized.x)
			
			var pt = before_point + ortho * size_cell_quarter - direction_normalized * size_cell_quarter
			var pt2 = pt + direction
			var pt3 = pt - ortho * size_cell_half
	#			print("i : ", i, " pt : ", pt)
			geometry.set_normal(Vector3(0,1,0))
			geometry.add_vertex(pt3)
			geometry.add_vertex(pt2)
			geometry.add_vertex(pt)
			geometry.add_vertex(pt2)
			geometry.add_vertex(pt3)
			geometry.add_vertex(pt2 - ortho * size_cell_half)
			
	geometry.end()
	return geometry
	
func compare_nodes(var node1, var node2):
	if node1.cost_f < node2.cost_f:
		return true
	return false
	
func euclidian_dist(var start, var target):
	return (start.x - target.x) * (start.x - target.x) + (start.y - target.y) * (start.y - target.y)
	
func shortest_path(var start, var target, var matrix, var list_neighbor_ofsets, var black_list_groups = []):
	var closed_list = {}
	var open_list = []
	var dist = euclidian_dist(start, target)
	var current_node = {"position" : start, "cost_g" : 0, "cost_h" : dist, "cost_f" : dist, "parent" : start}
	open_list.push_back(current_node)
	while (current_node.position.x != target.x || current_node.position.y != target.y) && !open_list.empty():
		# take the best node
		current_node = open_list.pop_front()
		# add node in the closed list
		closed_list[current_node.position] = current_node
		# search neighbor and add to the opened list
		for offset in list_neighbor_ofsets: 
			var neighbour_position = current_node.position + offset
			var selectable = Tools.search_character(matrix.get_selectables_from_cell(neighbour_position), "Characters")
			var blocked = false
			if selectable:
				for group in black_list_groups:
					if selectable.is_in_group(group):
						blocked = true
			if blocked:
				continue
						
			# if the neighbour already is not visited
			if !closed_list.has(neighbour_position):
				# distance from start position to the current node position
				var cost_g = closed_list[current_node.position].cost_g + euclidian_dist(neighbour_position, current_node.position)
				# distance from the current node position to the target position
				var cost_h = euclidian_dist(neighbour_position, target)
				# distance from start position to the current node by the finding path 
				# and then distance to the target by piou piou back
				var cost_f = cost_g + cost_h
				# set the parent to build the final path in the end ()
				# it's a position because it's the used key for the map (don't use pointers, not safe with a map -> need to think like communist, not like arnarchist #privatejoke)
				var parent = current_node.position
				# search inside the array ... O(n) not crazy, but no ordered map -> log(n)
				var find_index = -1
				for i in range(open_list.size()):
					if open_list[i].position == neighbour_position:
						find_index = i
						break
				# if the neighbour is in the open list, need to check if the node is better.
				# if not, replace this node by the neighbour
				# + sort the list regards to the criterion
				if find_index != -1:
					var find = open_list[find_index]
					if cost_f < find.cost_f:
						open_list[find_index] = {"position" : neighbour_position, "cost_g" : cost_g, "cost_h" : cost_h, "cost_f" : cost_f, "parent" : parent}
						open_list.sort_custom(self, "compare_nodes")
				else:
					open_list.push_back({"position" : neighbour_position, "cost_g" : cost_g, "cost_h" : cost_h, "cost_f" : cost_f, "parent" : parent})
					open_list.sort_custom(self, "compare_nodes")
		# check if the current node is the target node, if yes, build the final path (for the revolucion!)
		if current_node.position.x == target.x && current_node.position.y == target.y:
			var final_path = []
			var node = closed_list[target]
			final_path.push_back(node.position)
			while node.position != start:
				node = closed_list[node.parent]
				final_path.push_back(node.position)
			return final_path
	return null
	
	
func save_value(var key, var value):
	self.values[key] = value
func get_value(var key):
	return self.values[key]
func load_value(var key):
	var value = self.values[key]
	self.values[key] = null
	return value
func has_value(var key):
	return self.values.has(key)
func clear_values():
	self.values.clear()
	
func search_character(var selectables, var group):
	if !selectables:
		return null
	for selectable in selectables:
		if selectable.is_in_group(group):
			return selectable
	return null
	
func right(var position, var orientation, var i = 1):
	return position + Vector2(orientation.y, -orientation.x) * i
func left(var position, var orientation, var i = 1):
	return position - Vector2(orientation.y, -orientation.x) * i
func behind(var position, var orientation, var i = 1):
	return position - orientation * i
func front(var position, var orientation, var i = 1):
	return position + orientation * i
	
func print_error(var message):
	print("##########################################################")
	print("------ERROR------")
	print(message)
	print("##########################################################")