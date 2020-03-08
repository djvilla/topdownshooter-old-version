extends "res://character/character.gd"

# Movement Variables
onready var MAX_SPEED = walking_speed
var walking_speed = 250
var running_speed = 400
var ACCELERATION = 2000
var motion = Vector2.ZERO

# Bullet Variables
onready var bullet_spawn = $BulletPoint
onready var bullet_noise = $BulletShot
export var bullet_speed = 1000
export var fire_rate = 0.2 # In seconds
var bullet = preload("res://character/player/Bullet/Bullet.tscn")
var can_fire = true


func _process(delta):
	# Player look at mous position
	look_at(get_global_mouse_position())

func _physics_process(delta):
	player_movement(delta)
	
	fire_gun()

# Function to create a new bullet instance, spawn it at the set bullet spawn,
# match it's rotation to the users rotation, and then give it a foward velocity
# in the set direction.
func fire_gun():
	#Check if player is pressing the fire key
	if Input.is_action_just_pressed("fire") and can_fire:
		var bullet_instance =bullet.instance()
		bullet_instance.position = bullet_spawn.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2.ZERO, Vector2(bullet_speed, 0).rotated(rotation))
		# Using properties above, spawn bullet
		get_tree().get_root().add_child(bullet_instance)
		bullet_noise.play(0.1) # 0.1 skips that click at the begining of the audio clip
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true


# Gets the input from the keyboard
func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	axis.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return axis.normalized() #Cuts off value at one so player doesn't move faster diagonally

# Logic handles all player movement
func player_movement(delta):
	var axis = get_input_axis()
	if axis == Vector2.ZERO:  #If we are getting movement
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	motion = move_and_slide(motion)

func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED) #Clamps it at the max speed
