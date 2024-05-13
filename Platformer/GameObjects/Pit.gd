extends Node2D

@onready var kill_box = $KillBox


func _on_camera_y_lock_body_entered(body):
	if (body.name == "Player"):
		body.set_camera_y_lock(true)

func _on_camera_y_free_body_entered(body):
	if (body.name == "Player"):
		body.set_camera_y_lock(false)

func _on_kill_box_body_entered(body):
	if (body.name == "Player"):
		print("Killing Player")
		body.fall_damage()

