extends Node

var level_coin_count = {"Level_1": 8, "Level_2": 7, "Level_3": 12, "Level_4": 12, 
"Old_Level_1": 5, "Old_Level_2": 7,"Test_Level": 3}
var saveSlot = "save1"

@export var settingSave: String = "user://settings.cfg"
@export var optionValue: int = 1
@export var optionName: String = "saveSlot"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings()
	saveSlot = "save%d" % (optionValue + 1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func coins_collected(lvl_name: String) -> int:
	var save_path = "user://%s/%s.save" % [saveSlot, lvl_name]
	if !FileAccess.file_exists(save_path):
		print("File does not exist")
		return 0
	var save = FileAccess.open(save_path, FileAccess.READ)
	return save.get_var()

func load_settings():
	var settings: ConfigFile = ConfigFile.new()
	var err = settings.load(settingSave)
	if err != OK:
		print(settingSave, " does not exist")
		return
	
	var prevSetting : int = settings.get_value("Settings", optionName, -1)
	print("error: ", err)
	if prevSetting == null:
		print(" does not exist in ", settingSave)
		return
	optionValue = prevSetting
