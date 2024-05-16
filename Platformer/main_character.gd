extends CharacterBody2D


enum MovementType {
	Stand,
	Walk,
	Air,
}

const SPEED = 600.0
const JUMP_VELOCITY = -600.0

@onready var player_vars = get_node("/root/Global")
@onready var game_manager = %GameManager

@onready var camera_2d = $Camera2D
var cameraLock : bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var last_on_ground = self.get_indexed("position")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var spiked_timer = $spiked
@onready var damage_particles = $DamageParticles

var pause_lock : bool = false
var player_lock : bool = false
#A combination of both to stop weird behviour of pausing
var comb_lock: bool = false

@export var canGrapple: bool = false
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

#audio var
@onready var walking_audio = $Sounds/WalkingAudio
@onready var grapple_audio = $Sounds/GrappleAudio
@onready var jump_audio = $Sounds/JumpAudio
@onready var spiked_audio = $Sounds/SpikedAudio


func _ready():
	spiked_timer.stop()
	pass

func set_respawn(coords : Vector2):
	last_on_ground = coords

func _physics_process(delta):
	
	#If player just landed play jump sound for landing
	if (movementType == MovementType.Air and is_on_floor()):
		jump_audio.play()
	
	#lock player when escape pressed, this is to prevent animation
	if Input.is_action_just_pressed("pause"):
		pause_lock = !pause_lock
	comb_lock = pause_lock or player_lock
	# Add the gravity.
	if !is_on_floor():
		velocity.y += gravity * delta
		movementType = MovementType.Air
	else:
		movementType = MovementType.Stand
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !comb_lock:
		velocity.y = JUMP_VELOCITY
		jump_audio.play()

	# Handle drop down
	if Input.is_action_just_pressed("down"):
		self.set_collision_mask_value(2, false)
	
	if Input.is_action_just_released("down"):
		self.set_collision_mask_value(2, true)
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	#Takes control away from player
	if comb_lock:
		direction = 0	

	if (direction == 0):
		if !comb_lock:
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
	var grapple_check: bool = Input.is_action_just_pressed("jump") and not is_on_floor() and !comb_lock and canGrapple
	if grapple_check:
		print("Attemptiong grapple")
		if ray_cast.is_colliding():
			print("Grapling")
			grapple_audio.play()
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
		
		if is_on_ice:
			velocity.x = move_toward(velocity.x, direction * (SPEED + 100), 10)
		else:
			if !walking_audio.playing:
				walking_audio.play()
			velocity.x = move_toward(velocity.x, direction * (SPEED + 100), 100)
	
	#Give me the behaviour for standing
	if movementType == MovementType.Stand:
		if is_on_ice:
			velocity.x = move_toward(velocity.x, 0, 5)
		else:
			velocity.x = move_toward(velocity.x, 0, 100)

	move_and_slide()


func remove_health(amount: int):
	game_manager.take_damage(amount)

func win_state():
	player_lock = true
	animated_sprite_2d.play("win")
	

func spike_damage():
	velocity = -velocity
	spiked_audio.play()
	if spiked_timer.is_stopped():
		animated_sprite_2d.play("damage")
		player_lock = true
		damage_particles.set_emitting(true)
		spiked_timer.start()
		remove_health(1)
		

func fall_damage():
	if spiked_timer.is_stopped():
		player_lock = true
		spiked_timer.start()
		remove_health(1)

func _on_spiked_timeout():
	spiked_timer.stop()
	set_last_ground()
	player_lock = false
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

func set_camera_y_lock(val: bool):
	if !val:
		print("Camera Free")
		camera_2d.limit_bottom = 10000000
		cameraLock = false
	else:
		print("Camera Lock")
		camera_2d.limit_bottom = position.y+256+64+16
		cameraLock = true
	

