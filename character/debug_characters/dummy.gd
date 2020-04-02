extends "res://character/character.gd"

func _process(delta):
	$HealthLabel.update_health_label(health_util.health)
