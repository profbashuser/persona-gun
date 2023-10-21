@icon("res://icon.svg")
class_name GunPosData
extends Resource

@export var sway_threshold = 1
@export var sway_lerp = 5

@export_group("sways")
@export var swayLeft : Vector3 = Vector3.ZERO
@export var swayRight : Vector3 = Vector3.ZERO
@export var swayNormal : Vector3 = Vector3.ZERO

