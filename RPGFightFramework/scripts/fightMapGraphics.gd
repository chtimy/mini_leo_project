#extends FightMap
#
#func activeCases(var function, var rangeEffect, var position, var TreeScript):
#	print(typeof(rangeEffect), typeof(position))
#	for i in range(m_matrix.size()):
#		for j in range(m_matrix[i].size()):
#			if TreeScript.resolveCondition([i, j, position.x, position.y, rangeEffect], function):
#				enableOverlayCases(Vector2(i, j))
#
#func enableOverlayCases(var position):
#	print("position : ", position)
#	if insideMatrix(position):
#		if freeCase(position):
#			m_matrix[position.x][position.y].overlay.set_visible(true)
#
#func disableAllOverlayCases():
#	for line in m_matrix:
#		for c in line :
#			c.overlay.set_visible(true)