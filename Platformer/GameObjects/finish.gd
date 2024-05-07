extends Area2D

@export_file() var next_lvl

@onready var game_manager = %GameManager
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var confetti_particles = $Confetti

func _on_body_entered(body):
	if (body.name == "Player"):
		body.win_state()
		confetti_particles.emmit()	
		animated_sprite_2d.play("default")
		


#Note that the finish flag calls game_won(), not the player
func _on_animated_sprite_2d_animation_finished():
	game_manager.game_won()
