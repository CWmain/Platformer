extends HBoxContainer

# Set the display pf health to the given health value
func display_health(health: int):

	var all = self.get_children(false)
	var full: Rect2 = Rect2(0,0,16,16)
	var empty: Rect2 = Rect2(16,0,16,16)
	var count = 0
	for container in all:
		if health == count:
			container.get_child(0).set_emitting(true)
			heart_shake(container)
		if count >= health:			
			container.texture.region = empty
			
		else:
			container.texture.region = full
		count += 1
	
	
	
func heart_shake(heart):
	heart.set_pivot_offset(heart.get_size()/2)
	var tween = get_tree().create_tween()
	tween.tween_property(heart, "rotation", PI/4, 0.1)
	tween.tween_property(heart, "rotation", -PI/4, 0.1)
	tween.tween_property(heart, "rotation", 0, 0.1)
	
