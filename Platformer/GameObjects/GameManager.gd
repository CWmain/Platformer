extends Node

@onready var player_vars = get_node("/root/Global")

@onready var points_lable = %Points

func add_points():
	player_vars.points += 1
	points_lable.text = "Points: %d" % [player_vars.points]
	print("Points: ", player_vars.points)

