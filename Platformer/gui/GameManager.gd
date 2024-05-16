extends Node

@export_file var next_level
@export_file var main_menu
@export_file var cur_level

@export var level_name : String = "Level_1"

#Given value on_ready otherwise uses wrong var
var save_path : String

@onready var global = $"/root/Global"

@onready var points_lable = %Points
@onready var fps = $UI/Panel/FPS
@onready var health_bar = $UI/Panel/Health_Bar

@onready var pause_menu = $UI/PauseMenu
@onready var win_menu = $UI/winMenu
@onready var loss_menu = $UI/lossMenu

var points = 0
@export var MAX_HEALTH = 3
@onready var health = MAX_HEALTH

var in_menu: bool = false

func _ready():
	save_path = "user://%s/%s.save" % [global.saveSlot, level_name]
	print("Current Level: ", level_name)
	health_bar.display_health(health)
	win_menu.set_next_level(next_level)
	win_menu.set_main_menu(main_menu)
	loss_menu.set_main_menu(main_menu)
	loss_menu.set_cur_level(cur_level)
	
func _process(_delta):
	fps.text = "FPS: %d" % [Engine.get_frames_per_second()]

	if !in_menu and Input.is_action_just_pressed("pause"):
		pause_menu.pauseMenu()

func take_damage(amount: int):
	health -= amount
	health_bar.display_health(health)
	if health > 3:
		return
		
	if health <= 0:
		game_loss()
	

func game_won():
	in_menu = true
	save_highscore()
	Engine.time_scale = 0
	win_menu.show()

func game_loss():
	in_menu = true
	var death_delay : Timer = Timer.new()
	
	add_child(death_delay)
	death_delay.one_shot = true
	death_delay.autostart = false
	death_delay.start(0.7)
	death_delay.timeout.connect(_death_delay_timeout)
		

func _death_delay_timeout():
	Engine.time_scale = 0
	loss_menu.show()

func add_points():
	self.points += 1
	points_lable.text = "Points: %d" % [self.points]
	print("Points: ", self.points)

func save_highscore():
	# Do nothing if new score is less or equal than 
	if (self.points <= global.coins_collected(level_name)):
		return

	#Check directory exists, otherwise make it
	var dir_path =  "user://"
	var dir = DirAccess.open(dir_path)
	if dir.dir_exists("%s/" % global.saveSlot):
		print("Dir exists")
	else:
		print("Dir doesn't exist")
		dir.make_dir("%s/" % global.saveSlot)

	var save = FileAccess.open(save_path, FileAccess.WRITE)

	save.store_var(self.points)
	save.close()

