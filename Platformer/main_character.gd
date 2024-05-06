extends CharacterBody2D


enum MovementType {
	Stand,
	Walk,
	Air
}

const SPEED = 600.0
const JUMP_VELOCITY = -800.0

@onready var player_vars = get_node("/root/Global")
@onready var game_manager = %GameManager

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var last_on_ground = self.get_indexed("position")

@onready var animated_sprite_2d = $AnimatedSprite2D

@export var grapple_angle: int = 45
@onready var ray_cast = $RayCast2D
@onready var chain = $chain

# Variable to make player immune to damage
var immune = false

var movementType : MovementType = MovementType.Walk

# -1 = left 0 = false 1 = right
var is_grappling = false
var is_on_ice = false
var is_facing = 1

var collision_point : Vector2
const grapple_length = 500

func _ready():
	pass

func set_respawn(coords : Vector2):
	last_on_ground = coords

func _physics_process(delta):
	# Add the gravity.
	if !is_on_floor():
		velocity.y += gravity * delta
		movementType = MovementType.Air
	else:
		movementType = MovementType.Stand
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle drop down
	if Input.is_action_just_pressed("down"):
		self.set_collision_mask_value(2, false)
	
	if Input.is_action_just_released("down"):
		self.set_collision_mask_value(2, true)
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	
	if (direction == 0):
		animated_sprite_2d.play("idle")
	else:
		movementType = MovementType.Walk if is_on_floor() else MovementType.Air
		animated_sprite_2d.play("run")
	
	if (direction > 0):
		is_facing = 1
		animated_sprite_2d.flip_h = false;
	elif (direction < 0):
		is_facing = -1
		animated_sprite_2d.flip_h = true;
	
	
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
	if Input.is_action_just_released("jump") && (is_grappling):
		print("Stop grappling")
		chain.set_indexed("size", Vector2(32, 32))
		chain.set_indexed("rotation", PI)

		is_grappling = false

	
	#Give me the modification to velocity that grappling does
	if is_grappling:
		print("Applying Grapple movement")
		var vector_to_collision_point: Vector2 = collision_point - self.get_indexed("position")	
		velocity += 20 * vector_to_collision_point * delta
		grapple_visuals()
		
		
	#Give me the modification to velocity that being in the air does
	if movementType == MovementType.Air:
		if !is_grappling:
			velocity.x += direction * SPEED * delta * 5
		#Only enable a max air speed while not grappling
		if abs(velocity.x) >= SPEED*2 && !is_grappling:
			velocity.x = move_toward(velocity.x, direction * (SPEED * 2), 100) 

	#Give me the modification to velocity that walking on the floor does
	if movementType == MovementType.Walk:
		velocity.x = move_toward(velocity.x, direction * (SPEED + 100), 100)
	
	#Give me the behaviour for standing
	if movementType == MovementType.Stand:
		if is_on_ice:
			velocity.x = move_toward(velocity.x, 0, 5)
		else:
			velocity.x = move_toward(velocity.x, 0, 100)

	move_and_slide()


func remove_health(amount: int):
	if immune == false:
		game_manager.take_damage(amount)
		$iframes.start()
		immune = true

func _on_iframes_timeout():
	immune = false
	$iframes.stop()
	pass # Replace with function body.

func grapple_visuals():
	# Graphics for hook
	var tip_loc = to_local(collision_point)
	var chain_base : Vector2 = chain.get_indexed("position")
	var length = (tip_loc - chain_base)
	print("Length ", length )
	print("Chain Base ", chain_base)
	print("Tip Loc", tip_loc)

	chain.set_indexed("size", Vector2(32, length.length()*4))
	chain.set_indexed("rotation", TAU/4 + chain_base.angle_to(tip_loc))

func set_last_ground():
	position = last_on_ground
	velocity = Vector2(0,0)
	
	pass

func set_is_on_ice(val : bool):
	
	is_on_ice = val



