extends Node3D

var damage = 10

@onready var anim = $animationcontainer

func shoot(aim: RayCast3D):
	if Input.is_action_pressed("fire"):
		if not anim.is_playing():
			if aim.is_colliding():
				var target = aim.get_collider()
				if target.is_in_group("Enemy"):
					target.health -= damage
		anim.play("shoot")
	else:
		anim.stop()
