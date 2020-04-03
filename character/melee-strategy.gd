static func melee_attack(area, attack_group, source, damage):
	if raycast.is_colliding():
		var body = raycast.get_collider()
		if body.is_in_group(attack_group) and body.has_node("Health"):
			body.take_damage(source, damage)
