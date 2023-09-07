extends Node3D

var mouse_mov
var swayThreshold = 1
var swayLerp = 5

@export var swayLeft : Vector3
@export var swayRight : Vector3
@export var swayNormal : Vector3

func _input(event):
	if event is InputEventMouseMotion:
		mouse_mov = -event.relative.x

func _process(delta):
	if mouse_mov != null:
		if mouse_mov > swayThreshold:
			rotation = rotation.lerp(swayLeft, swayLerp * delta)
		elif mouse_mov < -swayThreshold:
			rotation = rotation.lerp(swayRight, swayLerp * delta)
		else:
			rotation = rotation.lerp(swayNormal, swayLerp * delta)
	position.x = -get_parent().position.x / 2
