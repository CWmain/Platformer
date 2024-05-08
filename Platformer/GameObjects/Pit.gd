extends Node2D

@onready var kill_box = $KillBox


func _on_camera_y_lock_body_entered(body):
	if (body.name == "Player"):
		body.toggle_camera_y_lock()
	pass # Replace with function body.
	
func _on_camera_y_lock_body_exited(body):
	if (body.name == "Player"):
		body.toggle_camera_y_lock()
	pass # Replace with function body.

func _on_kill_box_body_entered(body):
	if (body.name == "Player"):
		print("Killing Player")
		body.fall_damage()
	pass # Replace with function body.



