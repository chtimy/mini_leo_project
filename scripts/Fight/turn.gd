extends Control

func _ready():
	pass
	
func add_characters(var characters):
	for i in range(characters.size()):
		var texture_rect = TextureRect.new()
		texture_rect.texture = characters[i].image
		var scale = get_size().y / texture_rect.texture.get_size().y
		texture_rect.set_scale(Vector2(scale,scale))
		add_child(texture_rect)