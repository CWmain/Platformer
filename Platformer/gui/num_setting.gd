extends Control

@export var bus_name : String
var bus_index : int

@export var settingSave: String
@export var optionValue: float
@export var optionName: String


@onready var line_edit = $VBoxContainer/HSplitContainer/LineEdit
@onready var h_slider = $VBoxContainer/HSplitContainer/HSlider
@onready var label = $VBoxContainer/Label


func load_settings():
	var settings: ConfigFile = ConfigFile.new()
	var err = settings.load(settingSave)
	if err != OK:
		print(settingSave, " does not exist")
		return
	
	var prevSetting = settings.get_value("Settings", optionName, -1)
	print("error: ", err)
	if prevSetting == -1:
		print(label, " does not exist in ", settingSave)
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

# Called when the node enters the scene tree for the first time.
func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	load_settings()
	label.text = optionName
	line_edit.text = "%.00f" % optionValue
	h_slider.value = optionValue
	set_volume(optionValue)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	pass


func _on_h_slider_value_changed(value):
	line_edit.text = "%.00f" % h_slider.value
	set_volume(h_slider.value)

func _on_line_edit_text_submitted(new_text):
	var clampedValue : float = clamp(float(new_text), 0, 100)
	
	print("Key enter ", clampedValue)
	line_edit.text = "%.00f" % clampedValue
	h_slider.value = clampedValue
	set_volume(clampedValue)
	pass # Replace with function body.

func set_volume(vol : float):
	print("Volume = ", vol/100)
	optionValue = vol
	save_settings()
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(vol/100))
