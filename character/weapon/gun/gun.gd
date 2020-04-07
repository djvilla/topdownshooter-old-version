extends Node2D

export var bullet_speed = 1000
export var fire_rate = 0.2 # In seconds
var bullet = preload("res://character/bullet/Bullet.tscn")
var can_fire = true #Helps to keep shots constant and not all at once


func use_weapon(character, can_melee, bullet_spawn, bullet_noise):
	if can_fire && can_melee:
		var bullet_instance = _create_bullet_instance(bullet, bullet_spawn, bullet_speed, character.rotation, character.rotation_degrees)
		# Using properties above, spawn bullet
		character.get_tree().get_root().add_child(bullet_instance)
		#Animates here for smoke or flash
		bullet_noise.play(0.1) # 0.1 skips that click at the begining of the audio clip
		can_fire = false
		yield(character.get_tree().create_timer(fire_rate), "timeout")
		can_fire = true

func _create_bullet_instance(bullet, bullet_spawn, bullet_speed, rotation, rotation_degrees):
	var bullet_instance = bullet.instance()
	bullet_instance.position = bullet_spawn.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2.ZERO, Vector2(bullet_speed, 0).rotated(rotation))
	return bullet_instance
