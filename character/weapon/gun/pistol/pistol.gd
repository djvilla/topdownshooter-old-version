extends "res://character/weapon/gun/gun.gd"

func _ready() -> void:
	# Overwrite inital values
	weapon_name = "Pistol"
	ammo_amount = max_ammo
	max_ammo = 40
	current_total_ammo = max_ammo
	clip_size = 10
	ammo_amount = clip_size
	fire_rate = 0.5
	damage = 2
	
