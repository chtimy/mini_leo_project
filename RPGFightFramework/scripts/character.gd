extends "res://RPGFightFramework/scripts/selectable.gd"

var m_actionNames
var m_graphics

func _init(var name, var position, var actionNames, var category, var graphics).(name, position, category):
	m_graphics = graphics
	m_actionNames = actionNames
	
func setPosition(var position, var map):
	.setPosition(position)
	m_graphics.set_translation(map.getObjectPosition(position))
	
func setRotationByAngle(var angle):
	var angleInRadians = angle * 2 * PI / 360.0
	m_graphics.rotate_y(angleInRadians)
	
func setRotationByVec(var vec):
	var angle = getCaracteristic("orientation").angle_to(vec)
	var way = getCaracteristic("orientation").cross(vec)
	if way.y < 0:
		angle = -angle
	setCaracteristic("orientation", vec)
	m_graphics.rotate_y(angle)

func setRotationToTarget(var target):
	var vec = (Vector3(target.x, 0, target.z) - Vector3(m_position.x, 0, m_position.z)).normalized()
	setRotationByVec(vec)

func _ready():
	self.add_child(m_graphics)
