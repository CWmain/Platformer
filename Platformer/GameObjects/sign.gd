extends Node2D

@export var sign_text: String
@onready var label = %DisplayedText

func _ready():
	label.text = "[center]%s[/center]" % sign_text
