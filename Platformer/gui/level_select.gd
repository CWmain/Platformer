extends Node2D

const LEVEL_BTN = preload("res://gui/lvl_button.tscn")

@export_dir var dir_path

@onready var grid = $MarginContainer/VBoxContainer/GridContainer

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
	btn.text = lvl_name
	btn.level_path = lvl_path
	grid.add_child(btn)