extends Node2D

@onready var options = $Options
@onready var main_menu = $MarginContainer
@onready var level_select = $levelSelect



func _on_options_pressed():
	options.show()
	main_menu.hide()



func _on_quit_pressed():
	get_tree().quit()



func _on_level_select_pressed():
	level_select.show()
	main_menu.hide()
	pass # Replace with function body.
