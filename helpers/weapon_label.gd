extends Label

var Player = load("res://character/player/player.gd")


func _on_Player_weapon_change(weapon):
	text = weapon.weapon_name
