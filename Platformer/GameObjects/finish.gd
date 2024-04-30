extends Area2D

@export_file() var next_lvl

@onready var game_manager = %GameManager


func _on_body_entered(body):
	if (body.name == "Player"):
		if (next_lvl == null):
			print("No assigned next level")
			pass	
		game_manager.save_highscore()
		print("Going to next lvl")
		get_tree().change_scene_to_file(next_lvl)

