extends Node

#struct Character
#{
	#string name
	#string category
	#string path to texture
	#int life
	#float %attack
	#float %defence
	#float ...
	#int actionNames []
	#int group
	#int nbDeplacementBase
	#int orientation
	#vector2 position
	#...
	#graphics
#}

var m_tileSize

var m_name
var m_life
var m_actionNames
var m_nbStepsBase
var m_category
var m_texturePaths
var m_attackPourcentage
var m_defensePourcentage
var m_position
var m_state
var m_menu
var m_graphics

func init(var scene, var name, var category, var pathsToTextures, var life, var attackPourcentage, var defensePoucentage, var actionNames, var nbStepsBase, var position, var state, var tileSize, var actions):
	m_tileSize= tileSize
	m_name = name
	m_life = life
	m_actionNames = actionNames
	m_category = category
	m_texturePaths = pathsToTextures
	m_attackPourcentage = attackPourcentage
	m_defensePourcentage = defensePoucentage
	m_nbStepsBase = nbStepsBase
	m_position = position
	m_state = "normal"
	#init menu
	m_menu = load("res://RPGFightFramework/scenes/menuActionsFight.tscn").instance()
	scene.add_child(m_menu)
	m_menu.init(actions, m_actionNames)
	m_menu.set_visible(false)
	#init graphics character (position, orientation)
	m_graphics = Sprite.new()
	m_graphics.set_texture(load(m_texturePaths[0]))
	m_graphics.set_scale(Vector2(tileSize, tileSize)/m_graphics.get_texture().get_size())
	m_graphics.set_position(m_position * tileSize)
	m_graphics.set_centered(false)
	m_graphics.set_z_index(1)
	scene.add_child(m_graphics)
	
func move(var newPosition):
	print(m_name, " bouge en ", newPosition)
	m_position = newPosition
	m_graphics.set_position(m_position * m_tileSize)

func applyEffect(var effect):
	print(m_name, " recoit ", effect)
	m_state = effect

func takeDamages(var nbPoints):
	print(m_name, " recoit ", nbPoints, " de dégats")
	m_life -= nbPoints