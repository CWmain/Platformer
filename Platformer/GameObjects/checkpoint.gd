extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
var reached : bool = false


func _on_area_2d_body_entered(body):
	if (reached == true):
		return
	if (body.name == "Player"):
		reached = true	
		body.set_respawn(self.position)
		animated_sprite_2d.play()
		print("Do Checkpoint stuff")
	
	pass # Replace with function body.
