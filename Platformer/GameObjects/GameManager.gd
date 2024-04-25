extends Node

var points = 0

@onready var points_lable = %Points

func add_points():
	points += 1
	points_lable.text = "Points: %d" % [points]
	print(points)

