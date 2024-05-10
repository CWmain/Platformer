extends CheckBox

@export var settingSave : String
const OPTION_NAME = "FullScreen"

func _ready():
	load_settings()

func _on_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2(1152,648))
		#1152 / 648
	save_settings(toggled_on)

func load_settings():
	var settings: ConfigFile = ConfigFile.new()
	var err = settings.load(settingSave)
	if err != OK:
		print(settingSave, " does not exist")
		return
	
	var prevSetting = settings.get_value("Settings", OPTION_NAME, null)
	print("error: ", err)
	if prevSetting == null:
		print(OPTION_NAME, " does not exist in ", settingSave)
		return
	
	button_pressed = prevSetting

func save_settings(isFull: bool):

	var settings: ConfigFile = ConfigFile.new()
	var err = settings.load(settingSave)
	if err != OK:
		print(settingSave, " does not exist")
		settings = ConfigFile.new()

	print("Saving ", OPTION_NAME, " with ", isFull)
	settings.set_value("Settings", OPTION_NAME, isFull)
	settings.save(settingSave)
