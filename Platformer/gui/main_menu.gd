extends Node2D

@onready var options = $Options
@onready var main_menu = $MarginContainer
@onready var level_select = $levelSelect
@onready var global = $"/root/Global"


func _on_options_pressed():
	options.show()
	main_menu.hide()



func _on_quit_pressed():
	get_tree().quit()



func _on_level_select_pressed():
	level_select.show()
	main_menu.hide()
	pass # Replace with function body.


func _on_continue_pressed():
	var continue_level = global.get_continue()
	if (continue_level == null):
		print("Error: continue_level path not set in pause menu")
		pass
	Engine.time_scale = 1
	get_tree().change_scene_to_file(continue_level)
	pass # Replace with function body.
