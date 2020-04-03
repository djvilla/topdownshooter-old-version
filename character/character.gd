extends KinematicBody2D

signal state_change(state)

#Utils script
const utils = preload("res://helpers/utils.gd")
# Health node
onready var health_util = $Health
# Tracks the state
var state = 0 # Base State, IDLE
# Transition will be like this: [state, event]
var _transitions = {}

export(String) var weapon_path = ""
var weapon = null

# For complex games, add an intalize function on the state label than
# pass this node to let it connect. For a small project, this is fine
func _ready() -> void:
	health_util.connect("health_changed", self, "_on_Health_health_change")
	#$StateLabel.setup(self)
	

# Take input and convert it to event
func change_state(event):
	var transition = [state, event]
	if not transition in _transitions:
		return
	
	state = _transitions[transition]
	enter_state()
	
	emit_signal("state_change", state)

func enter_state():
	pass

# Characters method to take damage
func take_damage(source, amount):
	if self.is_a_parent_of(source) or self == source:
		return
	health_util.take_damage(amount)

func _on_Health_health_change(new_health):
	#_change_state(State.IDLE)
	# Kill player
	if(new_health == 0):
		queue_free()

