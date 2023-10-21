extends Node3D

var mouse_mov
@export var data: GunPosData

func _input(event):
	if event is InputEventMouseMotion:
		mouse_mov = -event.relative.x

func _process(delta):
	if mouse_mov != null:
		if mouse_mov > data.sway_threshold:
			rotation = rotation.lerp(data.swayLeft, data.sway_lerp * delta)
		elif mouse_mov < -data.sway_threshold:
			rotation = rotation.lerp(data.swayRight, data.sway_lerp * delta)
		else:
			rotation = rotation.lerp(data.swayNormal, data.sway_lerp * delta)
	position.x = -get_parent().position.x / 2
