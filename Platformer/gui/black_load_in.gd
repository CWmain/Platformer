extends CanvasLayer

@onready var black = $CenterContainer/Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	tween.tween_property(black, "scale", Vector2(0,0), 1.5)
