extends KinematicBody2D

signal state_change(state)

#Utils script
const utils = preload("res://helpers/utils.gd")
# Tracks the state
var state = 0 # Base State, IDLE
# Transition will be like this: [state, event]
var _transitions = {}

export(String) var weapon_path = ""
var weapon = null

# For complex games, add an intalize function on the state label than
# pass this node to let it connect. For a small project, this is fine
func _ready() -> void:
	#$StateLabel.setup(self)
	pass
	

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


