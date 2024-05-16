extends Control

@export var reloadOnBack : bool = false
@export var previousMenu : Control
@onready var global = $"/root/Global"
@onready var level_coin_count = global.level_coin_count



func _on_back_pressed():
	if reloadOnBack:
		get_tree().reload_current_scene()
	self.hide()
	if (previousMenu != null):
		previousMenu.show()

	
func _on_delete_save_pressed():
	var save_path = "user://%s/%s.save"
	for level in level_coin_count:
		#No save then skip
		if !FileAccess.file_exists(save_path % [global.saveSlot, level]):
			print("No save for ", level)
			continue
		
		var dir = DirAccess.open("user://%s/" % global.saveSlot)
		dir.remove(str(level, ".save"))
		dir.list_dir_end()
	global.delete_continue()
	Engine.time_scale = 1

