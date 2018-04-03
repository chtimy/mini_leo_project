extends "res://RPGFightFramework/scripts/player.gd"

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