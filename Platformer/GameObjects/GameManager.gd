extends Node

@export var level_name : String = "Level_1"

var save_path = "user://%s.save" % level_name

@onready var global = $"/root/Global"

@onready var points_lable = %Points


var points = 0

func add_points():
	self.points += 1
	points_lable.text = "Points: %d" % [self.points]
	print("Points: ", self.points)

func save_highscore():
	# Do nothing if new score is less than 
	if (self.points < global.coins_collected(level_name)):
		return
	var save = FileAccess.open(save_path, FileAccess.WRITE)
	save.store_var(self.points)
	save.close()

