extends "res://character/weapon/gun/gun.gd"

func _ready() -> void:
	# Overwrite inital values
	weapon_name = "Pistol"
	ammo_amount = max_ammo
	fire_rate = 0.5
	damage = 2
	
