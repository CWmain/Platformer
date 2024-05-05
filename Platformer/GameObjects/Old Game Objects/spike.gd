extends Area2D


func _on_body_entered(body):
	if (body.name == "Player"):
		body.remove_health(1)
		
		print("Ouch")
	pass # Replace with function body.
