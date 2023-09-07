extends Area3D

const ENEMY = preload("res://scenes/enemyTest.tscn")
@export var enemy_positions:Array[Vector3] = []

var cur_player

var active = false

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var player = body
		if !active:
			for i in enemy_positions:
				var instance = ENEMY.instantiate()
				instance.position.z = i.z
				instance.position.x = i.x
				instance.position.y = i.y
				
				instance.set_target(player)
				
				add_child(instance)
				
		active = true
