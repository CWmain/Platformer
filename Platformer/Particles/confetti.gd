extends Node

@onready var confetti_red = $ConfettiRed
@onready var confetti_green = $ConfettiGreen
@onready var confetti_blue = $ConfettiBlue

# Called when the node enters the scene tree for the first time.

func emmit():
	print("Confetti!!!")
	confetti_blue.set_emitting(true)
	confetti_green.set_emitting(true)
	confetti_red.set_emitting(true)
