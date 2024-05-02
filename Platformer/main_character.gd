extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -800.0

@onready var player_vars = get_node("/root/Global")
@onready var game_manager = %GameManager




# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var last_on_ground = self.get_indexed("position")

@export var grapple_angle: int = 45

@onready var ray_cast = $RayCast2D
@onready var chain = $chain

var is_on_ice = false
# -1 = left 0 = false 1 = right
var is_grappling = false

var is_facing = 1

var collision_point : Vector2
const grapple_length = 500

func _ready():
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

	# Handle drop down
	if Input.is_action_just_pressed("down"):
		self.set_collision_mask_value(2, false)
	
	if Input.is_action_just_released("down"):
		self.set_collision_mask_value(2, true)
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if (direction > 0):
		is_facing = 1
	elif (direction < 0):
		is_facing = -1
	
	
	# Set graple direction
	if is_facing == -1:
		ray_cast.set_indexed("rotation", -grapple_angle)
		
	else:
		ray_cast.set_indexed("rotation", grapple_angle)
		
	# Do graple
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		print("Attemptiong grapple")
		if ray_cast.is_colliding():
			print("Grapling")
			
			collision_point = ray_cast.get_collision_point()
			is_grappling = true
			
	# Stop grapple
	if Input.is_action_just_released("jump") && is_grappling:
		print("Stop grappling")
		chain.set_indexed("size", Vector2(32, 32))
		chain.set_indexed("rotation", TAU/2)
		is_grappling = false
	
	if is_grappling:
		
		#self.set_indexed("position", collision_point)
		var vector_to_collision_point: Vector2 = collision_point - self.get_indexed("position")
		
		velocity += 20 * vector_to_collision_point * delta
		

		#chain.set_indexed("size", Vector2(32+abs(vector_to_collision_point.x), 32))
		# Multiply by is_facing to change directions
		#velocity.x += 100 * is_facing
		# For distance from graple point x increase y
		#velocity.y += -100 - abs(collision_point.x - grapple_length)/80
		
		var max_grapple_height : bool = (collision_point.y - grapple_length) > self.get_indexed("position").y
		var max_grapple_left : bool = (collision_point.x - (grapple_length)) > self.get_indexed("position").x
		var max_grapple_right : bool = (collision_point.x + (grapple_length)) < self.get_indexed("position").x
		
		#Stop grappling
		if (max_grapple_height or max_grapple_left or max_grapple_right):
			print("Forced to stop grappling")
			is_grappling = false
	else:
		if direction:
			if is_on_floor():			
				velocity.x = direction * (SPEED + 100)
			else:
				velocity.x += direction * SPEED * delta * 5
				if abs(velocity.x) >= SPEED*2:
					velocity.x = direction * (SPEED * 2)
		else:
			if (is_on_ice == true):
				velocity.x = move_toward(velocity.x, 0, 5)
			else:
				velocity.x = move_toward(velocity.x, 0, 100)

	move_and_slide()
	
	if is_grappling:
		var tip_loc = to_local(collision_point)
		var chain_base : Vector2 = chain.get_indexed("position")
		var length = (tip_loc - chain_base)
		print("Length ", length )
		print("Chain Base ", chain_base)
		print("Tip Loc", tip_loc)

		chain.set_indexed("size", Vector2(32, length.length()*4))
		chain.set_indexed("rotation", TAU/4 + chain_base.angle_to(tip_loc))

func remove_health(amount: int):
	game_manager.take_damage(amount)


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

