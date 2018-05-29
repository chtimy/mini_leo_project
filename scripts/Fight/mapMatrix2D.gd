extends "res://scripts/Fight/mapMatrix.gd"

var dimensions = Vector2(0, 0)
var origin = Vector2(0, 0)
var list_active_overlays = []

func _init(var dimensions, var origin, var size_cell).(size_cell):
	self.dimensions = dimensions
	self.origin = origin
		
func get_origin():
	return self.origin
	
func test_matrix_condition_function(var range_cond, var game):
	for i in range(dimensions.x):
		for j in range(dimensions.y):
			if range_cond.call_func(game, Vector3(i, j)):
				return true
	return false

# @function : is_overlay_cell_at_index
# @Description : Check whether the cell is overlayed
# @params :
#	index : Index in the matrix of the cell
func is_overlay_cell_at_index(var index):
	if is_inside_matrix_bounds(index):
		if self.matrix[index.x][index.y].has("overlay") && self.matrix[index.x][index.y].overlay:
			return true
	return false

# @function : disable_selection
# @Description : Remove all the overlay cells and hide the cursor
func disable_selection():
	remove_all_overlay_cells()

# @function : remove_all_overlay_cells
# @Description : Remove all the overlay cells in the map
func remove_all_overlay_cells():
	while !self.list_active_overlays.empty():
		var index = self.list_active_overlays.pop_back()
		remove_overlay(index2D_to_index1D(index))
		matrix[index.x][index.y].overlay = null

# @function : add_overlay_cell_by_index
# @Description : Add overlay cell to the input index destination. 
#	No verification if the index in in the bound of the matrix
# @params :
#	index : Index in the matrix of the cell to add the overlay cell
func add_overlay_cell_by_index(var index):
	if !self.matrix[index.x][index.y].has("overlay") || self.matrix[index.x][index.y].overlay == null:
		# ATTENTION ici à l'offset de déplacement
		set_transform_overlay_mesh_instance(index2D_to_index1D(index), index_to_position(index))
		self.list_active_overlays.append(index)
		self.matrix[index.x][index.y].overlay = true
		return true
	return false

func index2D_to_index1D(var index2D):
	return index2D.y * self.matrix[0].size() + index2D.x
	
# @function : func add_overlay_cell_by_position(var position):
# @Description : Add overlay cell to the input position destination (position is normalized to the center of the cell). 
#	No verification if the index in in the bound of the matrix
# @params :
#	postition : Position of the overlay cell on the map
func add_overlay_cell_by_position(var position):
	var index = position_to_index(position)
	return add_overlay_cell_by_index(index)
	
func get_overlay(var index):
	.get_overlay(index2D_to_index1D(index))

func set_color_overlay_mesh_instance(var index_instance, var color):
	.set_color_overlay_mesh_instance(index2D_to_index1D(index_instance), color)
	
func position_to_index(var position):
	var pos = (position - get_origin()) / self.size_cell
	pos = pos.floor()
	return Vector2(round(pos.x), round(pos.y))
	
func index_to_position(var index):
	return index * self.size_cell + self.origin

# @function : is_inside_matrix_bounds
# @Description : Test if the input index is inside the matrix bound
# @params :
#	index : Index to check if inside the matrix bound
# @return
#	True if the index is inside the matrix bound, false otherwise
func is_inside_matrix_bounds(var index):
	if index.x >= self.matrix.size() || index.x < 0 || index.y >= self.matrix[index.x].size() || index.y < 0:
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
	if self.matrix[index.x][index.y].has(sth) && self.matrix[index.x][index.y][sth] != null:
		return true
	return false

# @function : add_selectable_to_cell
# @Description : Add a selectable to the cell at index
# @params :
#	selectable : Selectable to add to the cell
#	index : Index of the cell to add a selectable
func add_selectable_to_cell(var selectable, var index):
	if !self.matrix[index.x][index.y].has("selectables"):
		self.matrix[index.x][index.y]["selectables"] = []
	self.matrix[index.x][index.y].selectables.push_back(selectable)

# @function : move_selectable_to
# @Description : Move a selectable from a cell to another cell in the map. 
#				 BE CAREFUL : don't move the graphics selectable
# @params :
#	selectable : Selectable to move
#	index_from : Index of the cell to move away the selectable
#	index_to : Index of the cell to move in the selectable
# @return : True if the selectable is moved, false otherwise
func move_selectable_to(var selectable, var index_from, var index_to):
	var s = remove_selectable_from_cell(selectable, index_from)
	if s:
		add_selectable_to_cell(selectable, index_to)
		return true
	return false

# @function : remove_selectable_from_cell
# @Description : Remove a selectable from the cell.
# @params :
#	selectable : Selectable to remove
#	index : Index of the cell to remove the selectable
# @return : The removed selectable, null if the selectable doesn't exist in the cell
func remove_selectable_from_cell(var selectable, var index):
	var selectables = self.matrix[index.x][index.y].selectables
	if selectables:
		for i in range(selectables.size()):
			if selectable == selectables[i]:
				var s = selectables[i]
				selectables.remove(i)
				return s
	return null

# @function : get_selectables_from_cell
# @Description : Get the selectable in the map with the input index
# @params :
#	index : Index in the map of the selectable
# @return : The selectable if exists at the index position, null otherwise
func get_selectables_from_cell(var index):
	if !is_cell_contains_sth(index, "selectables"):
		return null
	return self.matrix[index.x][index.y].selectables

# @function : get_selectable_position_from_matrix
# @Description : Get the position in the map of the selectable with the input index
# @params :
#	index : Index in the matrix of the selectable
# @return : The position of the selectable on the map
func get_selectable_position_from_matrix(var index):
	var size_element = get_size_cell()
	if is_inside_matrix_bounds(Vector3(index.x, index.y)):
		return index * size_element
	else:
		return null
	
func print_selectables():
	for i in matrix.size():
		for j in matrix[i].size():
				if matrix[i][j].has("selectables"):
					print("cell : (",i,",",j, ") : ", matrix[i][j].selectables)