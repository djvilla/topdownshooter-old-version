extends RigidBody2D

#Determines how long a bullet travels before it is removed from the game
export var bullet_life = 1.5 #Setting for 15 seconds
onready var timer = $Timer

var damage = 1

func _ready():
	timer.set_wait_time(bullet_life)
	timer.connect("timeout", self, "_remove_bullet")
	timer.start()

func _on_Bullet_body_entered(body):
	if !body.is_in_group("character"):
		_remove_bullet()
	elif body.is_in_group("character") and body.has_node("Health"):
		body.take_damage(self, damage)
		_remove_bullet()

#Function removes the bullet from the current scene
func _remove_bullet():
	# Bullet impact animation
	
	# Remove Bullet
	queue_free()
