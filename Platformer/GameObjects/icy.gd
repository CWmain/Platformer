extends Area2D




func _on_body_entered(body):
	if (body.name == "Player"):
		print("On Ice New")
		body.set_is_on_ice(true)
	pass # Replace with function body.


func _on_body_exited(body):
	if (body.name == "Player"):
		print("Not on Ice")
		body.set_is_on_ice(false)
	pass # Replace with function body.
