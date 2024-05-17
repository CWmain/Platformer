extends Node

var level_coin_count = {"Level_1": 8, "Level_2": 7, "Level_3": 14, "Level_4": 14}
var saveSlot = "Save1"

@export var settingSave: String = "user://settings.cfg"
@export var optionValue: int = 1
@export var optionName: String = "saveSlot"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings()
	saveSlot = "Save%d" % (optionValue + 1)
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


func get_continue() -> String:
	var continueValue: String = "res://levels/Level_1.tscn"
	var continueName: String = "continue"
	
	var settings: ConfigFile = ConfigFile.new()
	var err = settings.load(settingSave)
	if err != OK:
		print(settingSave, " does not exist")
		return continueValue
	
	var prevSetting : String = settings.get_value(saveSlot, continueName, "NULL")
	print("error: ", err)
	if prevSetting == "NULL":
		print(" does not exist in ", settingSave)
		return continueValue
	
	continueValue = prevSetting
	
	return continueValue

func delete_continue():
	var config: ConfigFile = ConfigFile.new()
	var err = config.load(settingSave)
	if err != OK:
		print(config, " does not exist")
		return

	print("Deleteing save for ", saveSlot)
	config.erase_section(saveSlot)
	config.save(settingSave)

func save_continue(lvl_name: String):
	var settings: ConfigFile = ConfigFile.new()
	var err = settings.load(settingSave)
	if err != OK:
		print(settingSave, " does not exist")
		settings = ConfigFile.new()

	print("Saving continue with ", lvl_name)
	settings.set_value(saveSlot, "continue", lvl_name)
	settings.save(settingSave)
