extends "res://scripts/Fight/mapMatrix.gd"

var dimensions = Vector3(0, 0, 0)
var origin = Vector3(0,0,0)
var list_active_overlays = []

func _init(var dimensions, var origin).():
	self.dimensions = dimensions
	self.origin = origin
		
func get_origin():
	return self.origin
	
func test_matrix_condition_function(var range_cond, var game):
	for i in range(dimensions.x):
		for j in range(dimensions.y):
			for k in range(dimensions.z):
				if range_cond.call_func(game, Vector3(i, j, k)):
					return true
	return false

# @function : is_overlay_cell_at_index
# @Description : Check whether the cell is overlayed
# @params :
#	index : Index in the matrix of the cell
func is_overlay_cell_at_index(var index):
	if is_inside_matrix_bounds(index):
		if self.matrix[index.x][index.y][index.z].has("overlay") && self.matrix[index.x][index.y][index.z].overlay:
			return true
	return false

# @function : disable_selection
# @Description : Remove all the overlay cells and hide the cursor
func disable_selection():
	remove_all_overlay_cells()

# @function : remove_all_overlay_cells
# @Description : Remove all the overlay cells in the map
func remove_all_overlay_cells():
	var t = Transform(Basis(), Vector3(-1000, -1000, -1000))
	while !self.list_active_overlays.empty():
		var index = self.list_active_overlays.pop_back()
		set_transform_overlay_mesh_instance(index3D_to_index1D(index), t)
		matrix[index.x][index.y][index.z].overlay = null

# @function : add_overlay_cell_by_index
# @Description : Add overlay cell to the input index destination. 
#	No verification if the index in in the bound of the matrix
# @params :
#	index : Index in the matrix of the cell to add the overlay cell
func add_overlay_cell_by_index(var index):
	if !self.matrix[index.x][index.y][index.z].has("overlay") || self.matrix[index.x][index.y][index.z].overlay == null:
#		var overlayIndex = addInstanceOverlay()
		var transform = Transform(Basis(), indexToPosition(index))
		# ATTENTION ici à l'offset de déplacement
#		transform.origin = indexToPosition(index)
		set_transform_overlay_mesh_instance(index3D_to_index1D(index), transform)
		self.list_active_overlays.append(index)
		self.matrix[index.x][index.y][index.z].overlay = true
		return true
	return false

func index3D_to_index1D(var index3D):
	return index3D.y * self.matrix[0].size() * self.matrix[0][0].size() + index3D.x * self.matrix[0][0].size() + index3D.z
	
# @function : func add_overlay_cell_by_position(var position):
# @Description : Add overlay cell to the input position destination (position is normalized to the center of the cell). 
#	No verification if the index in in the bound of the matrix
# @params :
#	postition : Position of the overlay cell on the map
func add_overlay_cell_by_position(var position):
	var index = position_to_index(position)
	return add_overlay_cell_by_index(index)
	
func get_overlay(var index):
	.get_overlay(index3D_to_index1D(index))

func set_color_overlay_mesh_instance(var index_instance, var color):
	.set_color_overlay_mesh_instance(index3D_to_index1D(index_instance), color)
	
func position_to_index(var position):
	var pos = (position - get_origin()) / m_size_cell
	return Vector3(round(pos.x), round(pos.y), round(pos.z))
	
func indexToPosition(var index):
	return index * m_size_cell + self.origin

# @function : is_inside_matrix_bounds
# @Description : Test if the input index is inside the matrix bound
# @params :
#	index : Index to check if inside the matrix bound
# @return
#	True if the index is inside the matrix bound, false otherwise
func is_inside_matrix_bounds(var index):
	if index.x >= self.matrix.size() || index.x < 0 || index.y >= self.matrix[index.x].size() || index.y < 0|| index.z >= self.matrix[index.x][index.y].size() || index.z < 0:
		return false
	return true

# @function : is_cell_contains_selectable
# @Description : Check if the cell contains a selectable
# @params :
#	index : Index of the cell to check if there is a selectable
# @return :
#	True if the cell contains a selectable, false otherwise
# a completer au fur et a mesure des types de case
#du moins à modifier et faire en fct des catégories
func is_cell_contains_sth(var index, var sth):
	if self.matrix[index.x][index.y][index.z].has(sth) && self.matrix[index.x][index.y][index.z][sth] != null:
		return true
	return false

# @function : add_selectable_to_cell
# @Description : Add a selectable to the cell with the input index
# @params :
#	selectable : Selectable to add to the cell
#	index : Index of the cell to add a selectable
# a completer au fur et a mesure des types de case
#du moins à modifier et faire en fct des catégories
func add_selectable_to_cell(var selectable, var index):
	self.matrix[index.x][index.y][index.z].selectable = selectable

# @function : move_selectable_to
# @Description : Move a selectable from a cell to another cell in the map
# @params :
#	inindex_fromdexFrom : Index of the cell to move away the selectable
#	index_to : Index of the cell to move in the selectable
#move the selectable to the new position . BE CAREFUL : don't move the graphics selectable
func move_selectable_to(var index_from, var index_to):
	# don't check if the final position is busy by something or not
	if is_cell_contains_sth(index_from, "selectable"):
		self.matrix[index_to.x][index_to.y][index_to.z].selectable = self.matrix[index_from.x][index_from.y][index_from.z].selectable
		remove_selectable_from_cell(index_from)
		return true
	return false

# @function : remove_selectable_from_cell
# @Description : Remove a selectable from the cell. Just set cell.selectable to null
# @params :
#	index : Index of the cell to remove the selectable
func remove_selectable_from_cell(var index):
	self.matrix[index.x][index.y][index.z].selectable = null

# @function : get_selectable_froself.matrix
# @Description : Get the selectable in the map with the input index
# @params :
#	index : Index in the map of the selectable
# @return
#	The selectable if exists at the index position, null otherwise
func get_selectable_from_matrix(var index):
	if !is_cell_contains_sth(index, "selectable"):
		return null
	return self.matrix[index.x][index.y][index.z].selectable

# @function : get_selectable_position_froself.matrix
# @Description : Get the position in the map of the selectable with the input index
# @params :
#	index : Index in the matrix of the selectable
# @return
#	The position of the selectable on the map
func get_selectable_position_from_matrix(var index):
	var size_element = get_size_cell()
	var y = index.y
	while(is_inside_matrix_bounds(Vector3(index.x, y, index.z)) and self.matrix[index.x][y][index.z] == null):
		y+=1
	y-=index.y
	if is_inside_matrix_bounds(Vector3(index.x, y, index.z)):
		# ATTENTION : ici 0.75...
		return index * size_element + Vector3(0, size_element.y*y,0)
	else:
		return null
	
func on_surface(position):
	if (position.y == 0):# and self.matrix[position.x][position.y][position.z].type == 0 ) or ( is_inside_matrix_bounds(Vector3(position.x, position.y+1, position.z)) and self.matrix[position.x][position.y+1][position.z].type == 0 && self.matrix[position.x][position.y][position.z].type != 0 ) :
		return true
	return false