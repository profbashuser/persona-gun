extends Node3D



func _process(_delta: float) -> void:
	get_tree().call_group("Enemy", "set_target", get_node("Player"))
