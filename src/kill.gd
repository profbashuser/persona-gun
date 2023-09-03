extends Area3D

var player = null

var timer = 0
@export var wait_time = .5
@export var damage = 10

func _process(delta):
	if player != null:
		timer+=delta
		if timer>wait_time:
			
			player.health -= damage
			
			timer = 0
	else:
		timer = 0

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player = body

func _on_body_exited(body: Node3D) -> void:
	if body == player:
		player = null
