extends "res://character/character.gd"

const MoveStrategy = preload("res://character/player/move-strategy.gd")

# The state this player is in
enum States {
	IDLE,
	WALK,
	RUN
}

# Changes in the characters behavior
# Helps lead to different states
enum Events {
	INVALID=-1,
	STOP,
	IDLE,
	WALK,
	RUN
}

const SPEED = {
	States.WALK: 250,
	States.RUN: 400
}

const MOVE_STRATEGY = {
	States.WALK: MoveStrategy,
	States.RUN: MoveStrategy
}

# Movement Variables
onready var _max_speed = SPEED[States.WALK]
var ACCELERATION = 2000
var motion = Vector2.ZERO

# Bullet Variables
onready var bullet_spawn = $BulletPoint
onready var bullet_noise = $BulletShot
export var bullet_speed = 1000
export var fire_rate = 0.2 # In seconds
var bullet = preload("res://character/player/Bullet/Bullet.tscn")
var can_fire = true

# Constuctor, to overwrite _transitions
func _init() -> void:
	# All state transitions when an event occurs
	_transitions = {
		[States.IDLE, Events.WALK]: States.WALK,
		[States.IDLE, Events.RUN]: States.RUN,
		[States.WALK, Events.STOP]: States.IDLE,
		[States.WALK, Events.RUN]: States.RUN,
		[States.RUN, Events.STOP]: States.IDLE,
		[States.RUN, Events.WALK]: States.WALK,
	}

func _process(delta):
	# Player look at mous position
	look_at(get_global_mouse_position())

func _physics_process(delta):
	# Get the players input
	var input = get_raw_input(state)
	# Get the event
	var event = decode_raw_input(input)
	#Change state
	change_state(event)
	#Apply movement for given state
	player_movement(delta, input)
	
	fire_gun()

# Gets the input of the player
static func get_raw_input(state):
	return {
		direction = utils.get_input_direction(),
		is_running = Input.is_action_pressed("run")
	}

#Gets an event out from the given input
static func decode_raw_input(input):
	var event = Events.INVALID
	
	# If it has a direction
	if input.direction == Vector2.ZERO:
		event = Events.STOP
	elif input.is_running:
		event = Events.RUN
	else:
		event = Events.WALK
	
	# Override what happends above as these have precedents
	#if input.is_jumping:
	#	event = Events.JUMP
	#if input.is_bumping:
	#	event = Events.BUMP
	
	return event 

# Logic changes variables for each state to each state
func enter_state():
	match state:
		States.IDLE:
			#$AnimationPlayer.play("BASE")
			continue
		
		States.IDLE:
			motion = Vector2.ZERO
			_max_speed = SPEED[States.WALK]
		
		States.WALK, States.RUN:
			_max_speed = SPEED[state]
			#$AnimationPlayer.play("move")

# Logic handles player movement for each state
func player_movement(delta, input):
	match state:
		States.WALK, States.RUN:
			motion = MOVE_STRATEGY[state].go(input.direction, ACCELERATION, _max_speed, motion, delta)
			move_and_slide(motion)

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
