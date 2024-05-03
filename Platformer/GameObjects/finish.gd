extends Area2D

@export_file() var next_lvl

@onready var game_manager = %GameManager


func _on_body_entered(body):
	if (body.name == "Player"):
		game_manager.game_won()

