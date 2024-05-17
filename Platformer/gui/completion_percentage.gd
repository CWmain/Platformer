extends Control

@onready var global = $"/root/Global"
@onready var level_coin_count = global.level_coin_count

@onready var percent = $Percent

# Called when the node enters the scene tree for the first time.
func _ready():
	var value: float = calculate_percent() * 100
	percent.text = "%.0f%%" % value
	pass # Replace with function body.


func calculate_percent() -> float:
	var totalCoins: float = 0
	var collectedCoins: float = 0
	for level in level_coin_count:
		totalCoins += level_coin_count[level]
		collectedCoins += global.coins_collected(level)
	return (collectedCoins/totalCoins)
	
