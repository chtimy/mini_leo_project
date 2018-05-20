	extends Control

func _ready():
	var characters = get_node("..").characters
	var container = get_node("../HUD/turn_counter")
	for i in range(characters.size()):
		var textureRect = TextureRect.new()
		textureRect.texture = characters[i].image
		var scale = container.get_size().y / textureRect.texture.get_size().y
		print(scale)
		textureRect.set_expand(true)
		textureRect.set_custom_minimum_size(Vector2(40,40))
		container.add_child(textureRect)
	set_process(true)