extends RigidBody2D

#Determines how long a bullet travels before it is removed from the game
export var bullet_life = 1.5 #Setting for 15 seconds

func _process(delta):
	yield(get_tree().create_timer(bullet_life), "timeout")
	queue_free()

func _on_Bullet_body_entered(body):
	if !body.is_in_group("character"):
		queue_free()
