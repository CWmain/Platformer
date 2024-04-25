extends Button

@export_color_no_alpha var hover_color
@export_color_no_alpha var default_color

@export_file var level_path



func _on_color_rect_mouse_entered():
	get_node("ColorRect").color = hover_color
	pass # Replace with function body.
	
func _on_color_rect_mouse_exited():
	get_node("ColorRect").color = default_color
	pass # Replace with function body.

func _on_pressed():
	if level_path == null:
		print("Invalid level_path")
		return
		
	get_tree().change_scene_to_file(level_path)
	pass # Replace with function body.
