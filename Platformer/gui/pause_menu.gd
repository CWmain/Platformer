extends Control

@export_file var main_menu_path
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()

func pauseMenu():
	if paused:
		self.hide()
		Engine.time_scale = 1
	else:
		self.show()
		Engine.time_scale = 0
	paused = !paused


func _on_quit_pressed():
	get_tree().quit()


func _on_main_menu_pressed():
	if (main_menu_path == null):
		print("Error: main menu path not set in pause menu")
		pass
	Engine.time_scale = 1
	get_tree().change_scene_to_file(main_menu_path)



func _on_resume_pressed():
	
	pauseMenu()


func _on_options_pressed():
	$MarginContainer.hide()
	$Options.show()
	pass # Replace with function body.
