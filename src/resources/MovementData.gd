@icon("res://icon.svg")
class_name MovementData
extends Resource

@export var SENSITIVITY := 0.01

@export_group("Max Values")
@export var MAX_HEALTH:float = 100

@export_group("Speed And Acceleration")
@export var WALK_SPEED := 8.0
@export var RUN_SPEED := 9.6
@export var SLIDE_SPEED := 11.0
@export var GROUND_ACCEL := 9.0
@export var GROUND_DECEL := 7.0
@export var AIR_LERP := 3.0

@export_group("Jumping")
@export var JUMP_VELOCITY := 4.5
@export var BONUS_JUMPS := 2
@export var GRAVITY := 9.8

@export_group("Camera Effects")
@export var BOB_FREQ := 2.0
@export var BOB_AMP := 0.08
@export var VIEW_TILT := 0.1
@export var TILT_LERP := 9.0

