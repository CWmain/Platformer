extends OptionButton

@export var settingSave: String = "user://settings.cfg"
@export var optionValue: int = 1
@export var optionName: String = "saveSlot"


@onready var global = $"/root/Global"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings()
	self.selected = optionValue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

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


func save_settings():

	var settings: ConfigFile = ConfigFile.new()
	var err = settings.load(settingSave)
	if err != OK:
		print(settingSave, " does not exist")
		settings = ConfigFile.new()

	print("Saving ", optionName, " with ", optionValue)
	settings.set_value("Settings", optionName, optionValue)
	settings.save(settingSave)


func _on_item_selected(index):
	global.saveSlot = self.get_item_text(index)
	optionValue = index
	print(global.saveSlot)
	save_settings()

