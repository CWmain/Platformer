extends Area2D

@onready var game_manager = %GameManager
@onready var coin_audio = $coinAudio

#Prevent coin from being collected twice before audio ends
var collected : bool = false

func _on_body_entered(body):
	if (body.name == "Player" && !collected):
		coin_audio.play()
		collected = true
		self.hide()
		game_manager.add_points()


func _on_coin_audio_finished():
	queue_free()
	pass # Replace with function body.
