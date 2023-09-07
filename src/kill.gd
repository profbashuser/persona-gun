extends Area3D

var player = null

var timer = 0
@export var wait_time = .5
@export var player_damage = 10
@export var enemy_damage = player_damage

func _process(delta):
	if player != null:
		timer+=delta
		if timer>wait_time:
			
			player.health -= player_damage
			
			timer = 0
	else:
		timer = 0

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player = body
	elif body.is_in_group("Enemy"):
		body.health -= 1000

func _on_body_exited(body: Node3D) -> void:
	if body == player:
		player = null
