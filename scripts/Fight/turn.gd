extends Control

#order of turns
var turns = []
	
func add_character(var character):
	turns.append(turns.size())
	var texture_rect = TextureRect.new()
	texture_rect.texture = character.image
	var scale = get_size().y / texture_rect.texture.get_size().y
	texture_rect.set_scale(Vector2(scale,scale))
	add_child(texture_rect)
	
func get_current_turn():
	return self.turns.front()
	
func next_turn():
	self.turns.push_back(self.turns.pop_front())
	var first = get_child(0)
	move_child(first, get_children().size()-1)