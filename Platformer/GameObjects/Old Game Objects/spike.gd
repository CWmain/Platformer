extends Area2D


func _on_body_entered(body):
	if (body.name == "Player"):
		body.set_last_ground()
		body.remove_health(1)
		print("Ouch")
	pass # Replace with function body.
