extends "res://RPGFightFramework/scripts/selectable.gd"

#struct Character
#{
	#string category
	#string path to texture
	#int life
	#float %attack
	#float %defence
	#int actionNames []
	#int nbDeplacementBase
	#graphics
#}

var m_tileSize
var m_life
var m_actionNames
var m_nbStepsBase
var m_category
var m_texturePaths
var m_attackPourcentage
var m_defensePourcentage
var m_state
var m_graphics

func init(var scene, var name, var category, var pathsToTextures, var life, var attackPourcentage, var defensePoucentage, var actionNames, var nbStepsBase, var position, var state, var tileSize, var actions):
	.init(name, position)
	m_tileSize= tileSize
	m_life = life
	m_actionNames = actionNames
	m_category = category
	m_texturePaths = pathsToTextures
	m_attackPourcentage = attackPourcentage
	m_defensePourcentage = defensePoucentage
	m_nbStepsBase = nbStepsBase
	m_position = position
	m_state = "normal"
	initGraphics(scene)
	
func initGraphics(var scene):
	#init graphics character (position, orientation)
	m_graphics = Sprite.new()
	m_graphics.set_texture(load(m_texturePaths[0]))
	m_graphics.set_scale(Vector2(tileSize, tileSize)/m_graphics.get_texture().get_size())
	m_graphics.set_position(m_position * tileSize)
	m_graphics.set_centered(false)
	m_graphics.set_z_index(1)
	scene.add_child(m_graphics)