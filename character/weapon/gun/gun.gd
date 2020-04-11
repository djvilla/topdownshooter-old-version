extends Node2D

signal ammo_amount_changed(ammo_amount, max_ammo)

var weapon_name = ""

export var bullet_speed = 1000
export var fire_rate = 1 # In seconds, "1" = 10 seconds
onready var bullet_sfx = $BulletShot
var bullet = preload("res://character/bullet/Bullet.tscn")
var bullet_noise = load("res://sound/gun_revolver_pistol_shot_01.wav")
var bullet_noise_empty= load("res://sound/gun_pistol_dry_fire_01.wav")
var can_fire = true #Helps to keep shots constant and not shooting all at once
var damage = 1

var max_ammo = 10
var ammo_amount

func _ready():
	get_tree().get_root().get_node("Debug_World/Interface/AmmoLabel").setup(self)

# Allows the character to fire the weapon when they can fire and when they are not meleeing
func use_weapon(character, is_not_using_melee, bullet_spawn):
	if can_fire && is_not_using_melee:
		if ammo_amount > 0:
			var bullet_instance = _create_bullet_instance(bullet_spawn, character.rotation, character.rotation_degrees)
			# Using properties above, spawn bullet
			character.get_tree().get_root().add_child(bullet_instance)
			# Animation here for smoke or flash
			# Reduce ammunition
			bullet_instance.set_damage(damage)
			_reduce_ammo()
			if bullet_sfx.stream != bullet_noise:
				bullet_sfx.stream = bullet_noise
		else:
			if bullet_sfx.stream != bullet_noise_empty:
				bullet_sfx.stream = bullet_noise_empty
		
		bullet_sfx.play() # 0.1 skips that click at the beginning of the audio clip
		# Set the fire rate boolean and timer 
		can_fire = false
		yield(character.get_tree().create_timer(fire_rate), "timeout")
		can_fire = true

# Update the signal when weapons are switched. For Label
func update_ammo():
	emit_signal("ammo_amount_changed", ammo_amount, max_ammo)

# This function creates an instance of a bullet on the given bullet spawn.
# matches the characters direction
func _create_bullet_instance(bullet_spawn, rotation, rotation_degrees):
	var bullet_instance = bullet.instance()
	bullet_instance.position = bullet_spawn.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2.ZERO, Vector2(bullet_speed, 0).rotated(rotation))
	return bullet_instance

# Reduce the amount of ammo the weapon currently has when called
func _reduce_ammo():
	ammo_amount -= 1
	update_ammo()
