extends Node

# Dictionnary of :
#struct Action
#{
#	string name
#	int actionId
#	string pathToTexture[]
#	int ptsAttack
#	int ptsDefence
#	int rangeEffect
#	Tree functionTree
#	String effects[]
#}

#map{
#	textures
#	initialPositions
#	matrix

#import actions file
func readActionsFile():
	#a optimiser
	var line
	var actionsFightFile = File.new()
	var actions = {
	}
	#a mettre en binaire
	if actionsFightFile.open("res://data/fightScene/actions.txt", File.READ) == 0:
		var nb = nextLine(actionsFightFile)
		for i in range(nb):
			var action = {
				name = nextLine(actionsFightFile),
				id = nextLine(actionsFightFile).to_int(),
				pathToTexture = [nextLine(actionsFightFile), nextLine(actionsFightFile)],
				type = nextLine(actionsFightFile).to_int(),
				target = nextLine(actionsFightFile).to_int(),
				functions = null,
				effects = []
			}
			var nbEffects = nextLine(actionsFightFile)
			for i in range(nbEffects):
				action.effects.append(nextLine(actionsFightFile))
			if actions.has(action.name) == true:
				print("Attention, clef double pour l'entrée dans le dictionnaire d'une action")
			else :
				actions[action.name] = action
		actionsFightFile.close()
		return actions
	return null

#import actions file
func readMapFile(var path):
	#a optimiser
	var line
	var mapFile = File.new()
	var map = {
	}
	#a mettre en binaire
	if mapFile.open(path, File.READ) == 0:
		#read textures
		var nb = nextLine(mapFile)
		map.textures = []
		for i in range(nb):
			map.textures.append(nextLine(mapFile))
		#read initial positions for characters (0) enemis (1) and objects (2)
		map.initialPositions = []
		for k in range(3):
			nb = nextLine(mapFile)
			map.initialPositions.append([])
			for i in range(nb):
				var a = nextLine(mapFile).split_floats(" ")
				map.initialPositions[k].append(Vector2(a[0], a[1]))
		#read matrix
		map.matrix = []
		var a = nextLine(mapFile).split_floats(" ")
		var sizeMatrix = Vector2(a[0], a[1])
		for i in range(sizeMatrix.x):
			map.matrix.append([])
			var b = nextLine(mapFile).split_floats(" ")
			for j in range(sizeMatrix.y):
				map.matrix[i].append(b[j])
		mapFile.close()
		return map
	return null

func nextLine(var actionsFightFile):
	if actionsFightFile.eof_reached():
		print("Attention fin de fichier atteint, la ligne suivante n'existe pas")
	var line = actionsFightFile.get_line()
	while lineOK(line) == 0 :
		line = actionsFightFile.get_line()
	return line

func lineOK(var line):
	if line.empty():
		return 0
	for c in line:
		#prob ici il faut mettre que des espaces avant!
		if c.match("*#"):
			return 0
	return 1