extends "res://character/character.gd"

const MoveStrategy = preload("res://character/move-strategy.gd")

# The state this player is in
enum States {
	IDLE,
	WALK,
	RUN,
	SNEAK,
	LOOT
}

# Changes in the characters behavior
# Helps lead to different states
enum Events {
	INVALID=-1,
	STOP,
	IDLE,
	WALK,
	RUN,
	SNEAK,
	LOOT,
	DONE
}

const SPEED = {
	States.WALK: 250,
	States.RUN: 400,
	States.SNEAK: 125
}

const MOVE_STRATEGY = {
	States.WALK: MoveStrategy,
	States.RUN: MoveStrategy,
	States.SNEAK: MoveStrategy
}

# Determines which states allow you to aim
const AIM = {
	States.IDLE: true,
	States.WALK: true,
	States.RUN: true,
	States.SNEAK: true,
	States.LOOT: false
}

# Movement Variables
onready var _max_speed = SPEED[States.WALK]
var ACCELERATION = 2000
var motion = Vector2.ZERO

# Bullet Variables
onready var bullet_spawn = $BulletPoint

# Melee variable
onready var melee = $MeleeHit
var attack_group = "character"
var melee_damage = 2
var melee_rate = 0.2
var can_melee = true # Helps make sure the melee isn't spammed

# Constuctor, to overwrite _transitions
func _init() -> void:
	# All state transitions when an event occurs
	_transitions = {
		[States.IDLE, Events.WALK]: States.WALK,
		[States.IDLE, Events.RUN]: States.RUN,
		[States.IDLE, Events.LOOT]: States.LOOT,
		[States.IDLE, Events.SNEAK]: States.SNEAK,
		[States.WALK, Events.STOP]: States.IDLE,
		[States.WALK, Events.RUN]: States.RUN,
		[States.WALK, Events.LOOT]: States.LOOT,
		[States.WALK, Events.SNEAK]: States.SNEAK,
		[States.RUN, Events.STOP]: States.IDLE,
		[States.RUN, Events.WALK]: States.WALK,
		[States.RUN, Events.LOOT]: States.LOOT,
		[States.RUN, Events.SNEAK]: States.SNEAK,
		[States.SNEAK, Events.STOP]: States.IDLE,
		[States.SNEAK, Events.WALK]: States.WALK,
		[States.SNEAK, Events.RUN]: States.RUN,
		[States.SNEAK, Events.LOOT]: States.LOOT,
		[States.LOOT, Events.DONE]: States.IDLE,
	}

func _ready() -> void:
	weapon_path = "res://character/weapon/gun/Gun.tscn"
	#if not weapon_path:
	#	return
	weapon = load(weapon_path).instance()
	# Add child to the tree
	add_child(weapon)
	

func _process(delta):
	# Player look at mouse position
	if AIM[state]:
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
	melee_attack()

# Gets the input of the player
static func get_raw_input(state):
	return {
		direction = utils.get_input_direction(),
		is_running = Input.is_action_pressed("run"),
		is_sneaking = Input.is_action_pressed("sneak"),
		is_looting = Input.is_action_just_pressed("loot"),
		is_done = Input.is_action_just_pressed("debug_done")
	}

#Gets an event out from the given input
static func decode_raw_input(input):
	var event = Events.INVALID
	
	# If it has a direction
	if input.direction == Vector2.ZERO:
		event = Events.STOP
	elif input.is_running:
		event = Events.RUN
	elif input.is_sneaking:
		event = Events.SNEAK
	else:
		event = Events.WALK
	
	# Override what happends above as these have precedents
	if input.is_looting:
		event = Events.LOOT
	if input.is_done:
		event = Events.DONE
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
		
		States.WALK, States.RUN, States.SNEAK:
			_max_speed = SPEED[state]
			#$AnimationPlayer.play("move")
		
		States.LOOT:
			motion = Vector2.ZERO

# Logic handles player movement for each state
func player_movement(delta, input):
	match state:
		States.WALK, States.RUN, States.SNEAK:
			motion = MOVE_STRATEGY[state].go(input.direction, ACCELERATION, _max_speed, motion, delta)
			move_and_slide(motion)

# Function to create a new bullet instance, spawn it at the set bullet spawn,
# match it's rotation to the users rotation, and then give it a foward velocity
# in the set direction.
func fire_gun():
	#Check if player is pressing the fire key, and if they can aim
	if Input.is_action_just_pressed("fire") and AIM[state]:
		weapon.use_weapon(self, can_melee, bullet_spawn)

func melee_attack():
	if Input.is_action_just_pressed("melee"):
		# Disable fireing while meleeing
		can_melee = false
		$AnimationPlayer.play("melee")

func _on_MeleeHit_body_entered(body):
	if body.is_in_group(attack_group):
		body.take_damage(self, melee_damage)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "melee":
		can_melee = true
