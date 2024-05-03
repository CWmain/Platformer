extends Node

@export_file var next_level
@export_file var main_menu
@export_file var cur_level

@export var level_name : String = "Level_1"

var save_path = "user://%s.save" % level_name

@onready var global = $"/root/Global"

@onready var points_lable = %Points

@onready var health_bar = $UI/Health_Bar

@onready var win_menu = $UI/winMenu
@onready var loss_menu = $UI/lossMenu

var points = 0
@export var health = 3

func _ready():
	health_bar.display_health(health)
	win_menu.set_next_level(next_level)
	win_menu.set_main_menu(main_menu)
	loss_menu.set_main_menu(main_menu)
	loss_menu.set_cur_level(cur_level)
	

func take_damage(amount: int):
	health -= amount
	health_bar.display_health(health)
	if health <= 0:
		game_loss()
	

func game_won():
	save_highscore()
	Engine.time_scale = 0
	win_menu.show()

func game_loss():
	Engine.time_scale = 0
	loss_menu.show()

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

