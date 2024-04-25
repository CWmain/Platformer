extends Area2D




func _on_body_entered(body):
	if (body.name == "Player"):
		print("On Spike")
		body.set_last_ground()
		body.remove_health(1)
		

	pass # Replace with function body.


func _on_body_exited(body):
	if (body.name == "Player"):
		print("Not on Spike")
	pass # Replace with function body.
