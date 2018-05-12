extends "res://scripts/Fight/mapMatrix.gd"

func _init().():
	pass
	
func get_origin():
	return get_transform().origin
	
func test_matrix_condition_function(var range_cond, var game):
	for i in range(m_matrix.size()):
		for j in range(m_matrix[i].size()):
			for k in range(m_matrix[i][j].size()):
				if range_cond.call_func(game, Vector3(i, j, k)):
					return true
	return false

func choose_tile():
	pass
#	if Input.is_action_just_released("ui_take"):
#		if is_case_overlayed(m_cursor.position):
#			return m_cursor.position
#	elif Input.is_action_just_released("ui_down"):
#		if inside_matrix(m_cursor.position + Vector3(0,0,1)):
#			move_cursor_to(m_cursor.position + Vector3(0,0,1))
#	elif Input.is_action_just_released("ui_up"):
#		if inside_matrix(m_cursor.position + Vector3(0,0,-1)):
#			move_cursor_to(m_cursor.position + Vector3(0,0,-1))
#	elif Input.is_action_just_released("ui_right"):
#		if inside_matrix(m_cursor.position + Vector3(1,0,0)):
#			move_cursor_to(m_cursor.position+ Vector3(1,0,0))
#	elif Input.is_action_just_released("ui_left"):
#		if inside_matrix(m_cursor.position + Vector3(-1,0,0)):
#			move_cursor_to(m_cursor.position+ Vector3(-1,0,0))
#	return null

# @function : is_overlay_cell_at_index
# @Description : Check whether the cell is overlayed
# @params :
#	index : Index in the matrix of the cell
func is_overlay_cell_at_index(var index):
	if m_matrix[index.x][index.y][index.z].has("overlay") && m_matrix[index.x][index.y][index.z].overlay:
		return true
	return false

# @function : disable_selection
# @Description : Remove all the overlay cells and hide the cursor
func disable_selection():
	set_cursor_visible(false)
	remove_all_overlay_cells()

# @function : remove_all_overlay_cells
# @Description : Remove all the overlay cells in the map
func remove_all_overlay_cells():
	for i in range(m_matrix.size() * m_matrix[0].size() * m_matrix[0][0].size()):
		var t = Transform(Basis(), Vector3(-1000, -1000, -1000))
		m_overlay_cells.get_multimesh().set_instance_transform(i, t)

# @function : add_overlay_cell_by_index
# @Description : Add overlay cell to the input index destination. 
#	No verification if the index in in the bound of the matrix
# @params :
#	index : Index in the matrix of the cell to add the overlay cell
func add_overlay_cell_by_index(var index):
	if !m_matrix[index.x][index.y][index.z].has("overlay") || m_matrix[index.x][index.y][index.z].overlay == null:
#		var overlayIndex = addInstanceOverlay()
		var transform = Transform(Basis(), indexToPosition(index))
		# ATTENTION ici à l'offset de déplacement
#		transform.origin = indexToPosition(index)
		set_transform_overlay_meshinstance(index3D_to_index1D(index), transform)
		m_matrix[index.x][index.y][index.z].overlay = true
		return true
	return false

func index3D_to_index1D(var index3D):
	return index3D.y * m_matrix[0].size() * m_matrix[0][0].size() + index3D.x * m_matrix[0][0].size() + index3D.z
	
# @function : func addOverlayCellByPosition(var position):
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
	var pos = (position - get_position()) / m_size_cell
	return Vector3(round(pos.x), round(pos.y), round(pos.z))
	
func indexToPosition(var index):
	return index * m_size_cell + get_position()

# @function : is_inside_matrix_bounds
# @Description : Test if the input index is inside the matrix bound
# @params :
#	index : Index to check if inside the matrix bound
# @return
#	True if the index is inside the matrix bound, false otherwise
func is_inside_matrix_bounds(var index):
	if index.x >= m_matrix.size() || index.x < 0 || index.y >= m_matrix[index.x].size() || index.y < 0|| index.z >= m_matrix[index.x][index.y].size() || index.z < 0:
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
func is_cell_contains_selectable(var index):
	if !m_matrix[index.x][index.y][index.z].has("selectable") || m_matrix[index.x][index.y][index.z].selectable == null:
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
	m_matrix[index.x][index.y][index.z].selectable = selectable

# @function : move_selectable_to
# @Description : Move a selectable from a cell to another cell in the map
# @params :
#	inindex_fromdexFrom : Index of the cell to move away the selectable
#	index_to : Index of the cell to move in the selectable
#move the selectable to the new position . BE CAREFUL : don't move the graphics selectable
func move_selectable_to(var index_from, var index_to):
	# don't check if the final position is busy by something or not
	if is_cell_contains_selectable(index_from):
		m_matrix[index_to.x][index_to.y][index_to.z].selectable = m_matrix[index_from.x][index_from.y][index_from.z].selectable
		clear_cell(index_from)
		return true
	return false

# @function : remove_selectable_from_cell
# @Description : Remove a selectable from the cell. Just set cell.selectable to null
# @params :
#	index : Index of the cell to remove the selectable
func remove_selectable_from_cell(var index):
	m_matrix[index.x][index.y][index.z].selectable = null

# @function : get_selectable_from_matrix
# @Description : Get the selectable in the map with the input index
# @params :
#	index : Index in the map of the selectable
# @return
#	The selectable if exists at the index position, null otherwise
func get_selectable_from_matrix(var index):
	if !is_cell_contains_selectable(index):
		return null
	return m_matrix[index.x][index.y][index.z].selectable

# @function : get_selectable_position_from_matrix
# @Description : Get the position in the map of the selectable with the input index
# @params :
#	index : Index in the matrix of the selectable
# @return
#	The position of the selectable on the map
func get_selectable_position_from_matrix(var index):
	var size_element = get_size_cell()
	var y = index.y
	while(is_inside_matrix_bounds(Vector3(index.x, y, index.z)) and m_matrix[index.x][y][index.z] == null):
		y+=1
	y-=index.y
	if is_inside_matrix_bounds(Vector3(index.x, y, index.z)):
		# ATTENTION : ici 0.75...
		return get_origin() + index * size_element + Vector3(0, size_element.y*y*0.75,0)
	else:
		return null
	
func on_surface(position):
	if (position.y == 0 and m_matrix[position.x][position.y][position.z].type == 0 ) or ( is_inside_matrix_bounds(Vector3(position.x, position.y+1, position.z)) and m_matrix[position.x][position.y+1][position.z].type == 0 && m_matrix[position.x][position.y][position.z].type != 0 ) :
		return true
	return false