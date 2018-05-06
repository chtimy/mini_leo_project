extends Viewport

func changeMap(var map):
	var sprite = TextureRect.new()
	sprite.set_texture(.get_texture())
	sprite.set_expand(true)
	scene.get_node("..").set_custom_minimum_size(viewport * Vector2(0.1, 0.1))
	sprite.set_custom_minimum_size(viewport * Vector2(0.1, 0.1))
	sprite.set_script(load(PARENT_SCRIPT))
	sprite.m_parent = self
	sprite.connect("sprite_input", self, "on_sprite_input")
	m_mapLayouts.append(sprite)
