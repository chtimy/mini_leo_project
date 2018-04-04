extends "res://RPGFightFramework/scripts/character.gd"

var m_attackPourcentage
var m_defensePourcentage
var m_state
var m_nbStepsBase
var m_life

func init(var name, var position, var actionNames, var category, var tileSize, var pathsToTextures, var life, var attackPourcentage, var defensePoucentage, var nbStepsBase, var state, var scene):
	.init(name, position, actionNames, category, tileSize, pathsToTextures)
	m_life = life
	m_attackPourcentage = attackPourcentage
	m_defensePourcentage = defensePoucentage
	m_nbStepsBase = nbStepsBase
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