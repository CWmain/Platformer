extends Area2D

var player
var timerStart = false

func _on_body_entered(body):
	if (body.name == "Player"):
		player = body
		print("On Spike")
		body.velocity = -body.velocity
		if !timerStart:
			timerStart = true
			$GoToCheckpoint.start()
			body.remove_health(1)
		

	pass # Replace with function body.


func _on_body_exited(body):
	if (body.name == "Player"):
		print("Not on Spike")
	pass # Replace with function body.


func _on_go_to_checkpoint_timeout():
	$GoToCheckpoint.stop()
	timerStart = false
	player.set_last_ground()
	pass # Replace with function body.
