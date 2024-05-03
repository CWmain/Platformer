extends HBoxContainer

# Set the display pf health to the given health value
func display_health(health: int):

	var all = self.get_children(false)
	var full: Rect2 = Rect2(0,0,16,16)
	var empty: Rect2 = Rect2(16,0,16,16)
	var count = 0
	for container in all:
		if count >= health:
			container.get_child(0).set_emitting(true)
			container.texture.region = empty
		else:
			container.texture.region = full
		count += 1
	
	
	
