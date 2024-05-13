extends Node

var level_coin_count = {"Level_1": 8, "Level_2": 7, "Level_3": 12, "Old_Level_1": 5, "Old_Level_2": 7,"Test_Level": 3}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func coins_collected(lvl_name: String) -> int:
	var save_path = "user://%s.save" % lvl_name
	if !FileAccess.file_exists(save_path):
		print("File does not exist")
		return 0
	var save = FileAccess.open(save_path, FileAccess.READ)
	return save.get_var()
