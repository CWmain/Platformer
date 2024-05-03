extends Control

@export_file var main_menu_path
@export_file var next_level_path
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_next_level(next_level):
	self.next_level_path = next_level
	
func set_main_menu(main_menu):
	self.main_menu_path = main_menu


func _on_main_menu_pressed():
	if (main_menu_path == null):
		print("Error: main menu path not set in win page")
		pass
	Engine.time_scale = 1	
	get_tree().change_scene_to_file(main_menu_path)




func _on_next_level_pressed():
	if (next_level_path == null):
		print("Error: next_level_path path not set in win page")
		pass
	Engine.time_scale = 1	
	get_tree().change_scene_to_file(next_level_path)
