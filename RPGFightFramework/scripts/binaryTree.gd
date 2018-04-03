extends Node

func resolveCondition(var params, var map, var condition):
	var outMatrix = []
	for i in map.size():
		outMatrix.append([])
		for j in map[i].size():
			params[0] = i
			params[1] = j
			outMatrix[i].append(resolve(params, condition, 0))
	return outMatrix

func buildRangeActionFunction(var condition):
	var tabCondition = condition.split(" ");
	var rangeFunctionTree = []
	rangeFunctionTree.resize(tabCondition.size())
	var tree = buildTree(rangeFunctionTree, tabCondition, 0, 0).tree
	#TreeScript.printTree(tree, 0)
	return tree

func resolve(var params, var tree, var index):
	if !has_fils_gauche(index, tree) && !has_fils_droit(index, tree):
		return params[tree[index]]
	else:
		return tree[index].call_func(resolve(params, tree, fils_gauche(index)), resolve(params, tree, fils_droit(index)))
#pour rendre encore plus générique, faire une fonction qui ne récupère que le type de données à ajouter
func buildTree(var tree, var tabCondition, var i, var index):
	if index >= tree.size():
		tree.resize(index+2)
	var type
	if i < tabCondition.size():
		var terme = tabCondition[i]
		if terme == "i":
			tree[index] = 0
			type = 0
		if terme == "j":
			tree[index] = 1
			type = 0
		if terme == "POS.x":
			tree[index] = 2
			type = 0
		if terme == "POS.y":
			tree[index] = 3
			type = 0
		if terme == "RANGE":
			tree[index] = 4
			type = 0
		if terme == "<":
			tree[index] = funcref(get_script(), "operatorInf")
			type = 1
		if terme == ">":
			tree[index] = funcref(get_script(), "operatorSup")
			type = 1
		if terme == "<=":
			tree[index] = funcref(get_script(), "operatorInfEq")
			type = 1
		if terme == ">=":
			tree[index] = funcref(get_script(), "operatorSupEq")
			type = 1
		if terme == "==":
			tree[index] = funcref(get_script(), "operatorEq")
			type = 1
		if terme == "!=":
			tree[index] = funcref(get_script(), "operatorNoEq")
			type = 1
		if terme == "&&":
			tree[index] = funcref(get_script(), "operatorAnd")
			type = 1
		if terme == "||":
			tree[index] = funcref(get_script(), "operatorOr")
			type = 1
		if terme == "+":
			tree[index] = funcref(get_script(), "operatorAdd")
			type = 1
		if terme == "-":
			tree[index] = funcref(get_script(), "operatorLess")
			type = 1
		if type == 1 :
			i = buildTree(tree, tabCondition, i+1, fils_gauche(index)).i
			if fils_droit(index) < tree.size(): 
				i = buildTree(tree, tabCondition, i+1, fils_droit(index)).i
	var output = {
		tree = tree,
		i = i
	}
	return output

func fils_gauche(var index):
	return index*2+1

func fils_droit(var index):
	return index*2+2
	
func pere(var index):
	return index/2

func printTree(var tree, var index):
	if !has_fils_gauche(index, tree) && !has_fils_droit(index, tree):
		print(tree[index])
	else:
		tree[index].call_func(0, 2)
		if has_fils_gauche(index, tree):
			printTree(tree, fils_gauche(index))
		if has_fils_droit(index, tree):
			printTree(tree, fils_droit(index))

func has_fils_gauche(var index, var tree):
	return fils_gauche(index) < tree.size() && tree[fils_gauche(index)] != null
	
func has_fils_droit(var index, var tree):
	return fils_droit(index) < tree.size() && tree[fils_droit(index)] != null


static func operatorInf(var a, var b):
	print(a, "<", b)
	return a < b

static func operatorSup(var a, var b):
	print(a,">",b)
	return a > b

static func operatorInfEq(var a, var b):
	print(a,"<=",b)
	return a <= b
	
static func operatorSupEq(var a, var b):
	print(a,">=",b)
	return a >= b
	
static func operatorEq(var a, var b):
	print(a,"=",b)
	return a == b

static func operatorNoEq(var a, var b):
	print(a,"!=",b)
	return a != b
	
static func operatorAnd(var a, var b):
	print(a,"&&",b)
	return a && b
	
static func operatorOr(var a, var b):
	print(a, "||", b)
	return a || b
	
static func operatorAdd(var a, var b):
	print(a,"+",b)
	return a + b

static func operatorLess(var a, var b):
	print(a,"-",b)
	return a - b