extends Node

@onready var confetti_red = $ConfettiRed
@onready var confetti_green = $ConfettiGreen
@onready var confetti_blue = $ConfettiBlue

@onready var confetti_audio = $confettiAudio


func emmit():
	print("Confetti!!!")
	confetti_audio.play()
	confetti_blue.set_emitting(true)
	confetti_green.set_emitting(true)
	confetti_red.set_emitting(true)
