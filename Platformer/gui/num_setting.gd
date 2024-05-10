extends Control

@export var bus_name : String
var bus_index : int

@export var optionValue: int
@export var optionName: String

@onready var line_edit = $VBoxContainer/HSplitContainer/LineEdit
@onready var h_slider = $VBoxContainer/HSplitContainer/HSlider
@onready var label = $VBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	
	label.text = optionName
	line_edit.text = "%.00f" % optionValue
	h_slider.value = optionValue
	set_volume(optionValue)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
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
	print("%Volume = ", vol/100)

	AudioServer.set_bus_volume_db(bus_index, linear_to_db(vol/100))
