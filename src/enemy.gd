extends CharacterBody3D

const BLOOD = preload("res://scenes/misc/Blood.tscn")

@onready var agent = $NavigationAgent3D
var health = 100
var speed = 6.0

var target_pos

func _process(_delta):
	if health <= 0:
		var instance = BLOOD.instantiate()
		
		instance.position = position
		instance.position.y += 0.5
		
		get_parent().add_child(instance)
		
		instance.emitting = true
		
		queue_free()

func _physics_process(_delta: float) -> void:
	agent.target_position = (target_pos.global_transform.origin)
	
	var current_pos = global_transform.origin
	var next_location = agent.get_next_path_position()
	var new_vel = (next_location - current_pos).normalized() * speed
	
	velocity = new_vel
	
	move_and_slide()

func set_target(target):
	target_pos = target
