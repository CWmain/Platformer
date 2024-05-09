extends Control

@export var previousMenu : Control
@onready var global = $"/root/Global"
@onready var level_coin_count = global.level_coin_count


func _on_back_pressed():
	self.hide()
	if (previousMenu != null):
		previousMenu.show()
	pass # Replace with function body.
	
func _on_delete_save_pressed():
	var save_path = "user://%s.save"
	for level in level_coin_count:
		#No save then skip
		if !FileAccess.file_exists(save_path % level):
			print("No save for ", level)
			continue
		
		var dir = DirAccess.open("user://")
		dir.remove(str(level, ".save"))
		dir.list_dir_end()
	Engine.time_scale = 1
	# Reload whole scene to update the coin count (Should improve this)
	get_tree().reload_current_scene()
	pass # Replace with function body.
