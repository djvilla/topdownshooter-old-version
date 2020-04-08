extends Node2D

var weapon_name = ""

export var bullet_speed = 1000
export var fire_rate = 0.2 # In seconds
var noise_path = "res://sound/gun_revolver_pistol_shot_01.wav"
onready var bullet_noise = $BulletShot
var bullet = preload("res://character/bullet/Bullet.tscn")
var can_fire = true #Helps to keep shots constant and not shooting all at once

# Allows the character to fire the weapon when they can fire and when they are not meleeing
func use_weapon(character, is_not_using_melee, bullet_spawn):
	if can_fire && is_not_using_melee:
		var bullet_instance = _create_bullet_instance(bullet_spawn, character.rotation, character.rotation_degrees)
		# Using properties above, spawn bullet
		character.get_tree().get_root().add_child(bullet_instance)
		# Animation here for smoke or flash
		# 
		#bullet_noise.stream = load(noise_path)
		bullet_noise.play(0.1) # 0.1 skips that click at the beginning of the audio clip
		can_fire = false
		yield(character.get_tree().create_timer(fire_rate), "timeout")
		can_fire = true

# This function creates an instance of a bullet on the given bullet spawn.
# matches the characters direction
func _create_bullet_instance(bullet_spawn, rotation, rotation_degrees):
	var bullet_instance = bullet.instance()
	bullet_instance.position = bullet_spawn.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2.ZERO, Vector2(bullet_speed, 0).rotated(rotation))
	return bullet_instance
