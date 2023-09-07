class_name MovementData
extends Resource

@export var SENSITIVITY := 0.01

@export_group("Health")
@export var MAX_HEALTH:float = 100

@export_group("Speed")
@export var WALK_SPEED := 8.0
@export var WALLRUN_SPEED := 9.0
@export var SLIDE_SPEED := 9.6

@export_group("Jumping")
@export var JUMP_VELOCITY := 4.5
@export var MAX_JUMPS := 2
@export var GRAVITY := 9.8

@export_group("Camera effects")
@export var BOB_FREQ := 2.0
@export var BOB_AMP := 0.08
@export var VIEW_TILT := 0.1

