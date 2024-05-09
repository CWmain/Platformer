extends Node2D

const LEVEL_BTN = preload("res://gui/lvl_button.tscn")

#Manually enter level name and associated amount of coins in the level


@export_dir var dir_path

@onready var grid = $MarginContainer/VBoxContainer/GridContainer
@onready var global = $"/root/Global"
@onready var level_coin_count = global.level_coin_count

func _ready() -> void:
	get_levels(dir_path)


func get_levels(path) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			create_level_button("%s/%s" % [dir.get_current_dir(), file_name], file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Error accessing directory path in get_levels")
	
	
func create_level_button(lvl_path: String, lvl_name: String) -> void:
	var btn = LEVEL_BTN.instantiate()
	btn.text = lvl_name.trim_suffix(".tscn")
	btn.level_path = lvl_path
	
	var ctext = "%s / %s" % [global.coins_collected(lvl_name.trim_suffix(".tscn")), level_coin_count[lvl_name.trim_suffix(".tscn")]]
	print(ctext)
	btn.set_collected(ctext)
	
	grid.add_child(btn)


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
	# Reload whole scene to update the coin count (Should improve this)
	get_tree().reload_current_scene()
	pass # Replace with function body.


