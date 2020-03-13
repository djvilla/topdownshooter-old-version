extends Node

# Gets the input from the keyboard
static func get_input_direction(event=Input):
	var axis = Vector2.ZERO
	axis.x = event.get_action_strength("move_right") - event.get_action_strength("move_left")
	axis.y = event.get_action_strength("move_down") - event.get_action_strength("move_up")
	return axis.normalized() #Cuts off value at one so player doesn't move faster diagonally
