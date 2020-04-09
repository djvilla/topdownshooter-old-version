extends "res://character/weapon/gun/gun.gd"

func _ready() -> void:
	# Overwrite inital values
	weapon_name = "Machine Gun"
	max_ammo = 50
	ammo_amount = max_ammo
	fire_rate = 0.1
	bullet_noise = load("res://sound/gun_semi_auto_rifle_shot_01.wav")
