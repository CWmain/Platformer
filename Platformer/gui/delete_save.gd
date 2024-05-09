extends Button

@onready var global = $"/root/Global"
@onready var level_coin_count = global.level_coin_count

func _on_pressed():
	var save_path = "user://%s.save"
	for level in level_coin_count:
		#No save then skip
		if !FileAccess.file_exists(save_path % level):
			print("No save for ", level)
			continue
		
		var dir = DirAccess.open("user://")
		dir.remove(str(level, ".save"))
		dir.list_dir_end()
	# Reload whole scene to update the coin count (Should improve this)
	get_tree().reload_current_scene()
	pass # Replace with function body.
