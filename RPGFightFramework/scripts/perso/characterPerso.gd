extends "res://RPGFightFramework/scripts/character.gd"

var m_caracteristics

func _init(var name, var position, var actionNames, var category, var caracteristics, var graphics).(name, position, actionNames, category, graphics):
	m_caracteristics = caracteristics
	randomize()
	
func getCaracteristic(var name):
	return m_caracteristics.name

func setCaracteristic(var name, var value):
	m_caracteristics.name = value
	
func addCaracteristic(name, value):
	m_caracteristics.name.append(value)
	
func increaseCaracteristic(var name, var value):
	m_caracteristics.name += value
	
func decreaseCaracteristic(var name, var value):
	m_caracteristics.name -= value
	
func throwDiceForCaracteristic(var name):
	var result = throwDice(100)
	return result <= m_caracteristics.name
	
func throwDice(var maxNumber):
	return randi() % maxNumber + 1
	