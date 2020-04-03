extends Label

var Player = load("res://character/player/player.gd")

var _state_text = {
	Player.States.IDLE: "idle",
	Player.States.WALK: "walk",
	Player.States.RUN: "run",
	Player.States.LOOT: "loot",
	Player.States.SNEAK: "sneak",
}


func setup(character):
	character.connect("state_change", self, "_on_Character_state_changed")

func _on_Player_state_change(state):
	text = _state_text[state]
