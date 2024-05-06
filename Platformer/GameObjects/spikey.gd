extends Area2D

var player
var timerStart = false

func _on_body_entered(body):
	if (body.name == "Player"):
		body.spike_damage()
	pass # Replace with function body.


func _on_body_exited(body):
	if (body.name == "Player"):
		print("Not on Spike")
	pass # Replace with function body.
