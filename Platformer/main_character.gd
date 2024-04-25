extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -800.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var last_on_ground = self.get_indexed("position")
@export var health: int
@onready var health_label = %Health

@onready var ray_cast = $RayCast2D

var is_on_ice = false
# -1 = left 0 = false 1 = right
var is_grappling = false

var is_facing = 1

var collision_point : Vector2
const grapple_length = 150

func _ready():
	health_label.text = "Health: %d" % [health]
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		last_on_ground = self.get_indexed("position")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if (direction > 0):
		is_facing = 1
	elif (direction < 0):
		is_facing = -1
	
	
	# Set graple direction
	if is_facing == -1:
		ray_cast.set_indexed("rotation", -45)
	else:
		ray_cast.set_indexed("rotation", 45)
		
	# Do graple
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		if ray_cast.is_colliding():
			print("Grapling")
			
			collision_point = ray_cast.get_collision_point()
			is_grappling = true
			
	# Stop grapple
	if Input.is_action_just_released("jump") && is_grappling:
		print("Stop grappling")
		is_grappling = false
	
	if is_grappling:
		
		#self.set_indexed("position", collision_point)
		
		
		# Multiply by is_facing to change directions
		velocity.x += 100 * is_facing
		# For distance from graple point x increase y
		velocity.y += -100 - abs(collision_point.x - grapple_length)/80
		
		var max_grapple_height : bool = (collision_point.y - grapple_length) > self.get_indexed("position").y
		var max_grapple_left : bool = (collision_point.x - (grapple_length*2)) > self.get_indexed("position").x
		var max_grapple_right : bool = (collision_point.x + (grapple_length*2)) < self.get_indexed("position").x
		
		#Stop grappling
		if (max_grapple_height or max_grapple_left or max_grapple_right):
			print("Forced to stop grappling")
			is_grappling = false
	else:
		if direction:
			if is_on_floor():			
				velocity.x = direction * (SPEED + 100)
			else:
				velocity.x += direction * SPEED
				if abs(velocity.x) >= SPEED*2:
					velocity.x = direction * (SPEED * 2)
		else:
			if (is_on_ice == true):
				velocity.x = move_toward(velocity.x, 0, 5)
			else:
				velocity.x = move_toward(velocity.x, 0, 100)

	move_and_slide()

func remove_health(amount: int):
	health -= amount
	health_label.text = "Health: %d" % [health]

func set_last_ground():
	self.set_indexed("position", last_on_ground)
	pass

func set_is_on_ice(val : bool):
	is_on_ice = val


func _on_area_2d_body_entered(body):
	if (body.name == "ICE"):
		print("On Ice")
		is_on_ice = true
	else:
		is_on_ice = false
	print(body.name)
	pass # Replace with function body.

