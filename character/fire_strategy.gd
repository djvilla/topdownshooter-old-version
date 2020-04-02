static func create_bullet_instance(bullet, bullet_spawn, bullet_speed, rotation, rotation_degrees):
	var bullet_instance =bullet.instance()
	bullet_instance.position = bullet_spawn.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2.ZERO, Vector2(bullet_speed, 0).rotated(rotation))
	return bullet_instance
