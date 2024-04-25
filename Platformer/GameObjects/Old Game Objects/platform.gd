extends StaticBody2D

@onready var collision = $CollisionShape2D
#@onready var area = $Area2D

func _unhandled_input(event):
	if event.is_action_pressed("down"):
		collision.set_deferred("disabled", true)
	else:
		collision.set_deferred("disabled", false)
