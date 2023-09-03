extends CharacterBody3D

@export var data: PlayerMovementData

@onready var health: float = data.MAX_HEALTH

var speed: float

var wallrunning := false
var wall_normal

var sliding:bool = false
var slide_vec:Vector3 = Vector3.ZERO
var slide_vec_off:Vector3

var is_dead:bool = false

var t_bob = 0.0

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var collision = $CollisionShape3D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	speed = data.WALK_SPEED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if !is_dead:
			head.rotate_y(-event.relative.x * data.SENSITIVITY)
			camera.rotate_x(-event.relative.y * data.SENSITIVITY)
		
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	if !is_dead:
	
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= data.GRAVITY * delta
	
	# Handle Jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = data.JUMP_VELOCITY

		var input_dir := Input.get_vector("left", "right", "up", "down")
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if is_on_floor():
			if direction:
				velocity.x = lerp(velocity.x, direction.x * speed, delta * 9.0) # velocity.x = direction.x * speed
				velocity.z = lerp(velocity.z, direction.z * speed, delta * 9.0) # velocity.z = direction.z * speed
			else:
				velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
				velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
		
		if is_on_wall_only():
			if input_dir.y != 0 && input_dir.x != 0:
				wall_normal = get_slide_collision(0)
				wallrunning = true
				velocity.y = clamp(velocity.y, -.5, 1000000)
				speed = data.WALLRUN_SPEED
				if Input.is_action_just_pressed("jump"):
					velocity = wall_normal.get_normal() * speed
					velocity.y = data.JUMP_VELOCITY
		else:
			wallrunning = false
		
		if Input.is_action_pressed("slide") && !sliding:
			if input_dir != Vector2.ZERO:
				slide_vec = direction
			else:
				slide_vec = (head.transform.basis * Vector3(0, 0, -1)).normalized()
		
		if Input.is_action_pressed("slide") && is_on_floor():
			sliding = true
		elif !$SlideCast.is_colliding():
			sliding = false
		
		if sliding:
			collision.scale.y = lerp(collision.scale.y, .5,delta * 9.0)
			head.position.y = lerp(head.position.y, 0.0, delta * 8.0)
			
			var slide_speed:float = data.SLIDE_SPEED
			if speed/1.1 > data.SLIDE_SPEED:
				slide_speed = speed
			
			# Slide force
			velocity.x = slide_vec.x * (slide_speed)
			velocity.z = slide_vec.z * (slide_speed)
			
			if Input.is_action_just_pressed("jump"):
				speed *= (1.1)
			
		else:
			collision.scale.y = lerp(collision.scale.y, 1.0,delta * 9.0)
			head.position.y = lerp(head.position.y, .5, delta * 8.0)
		
		if is_on_floor() && !sliding:
			speed = move_toward(speed, data.WALK_SPEED, delta * 20.0)
		
		if $Head/Camera3D/Hand/debug.has_method("shoot"):
			$Head/Camera3D/Hand/debug.shoot($Head/Camera3D/Aimcast)
		
		t_bob += delta * velocity.length() * (float(is_on_floor())) * float(!sliding)
		camera.transform.origin = _headbob(t_bob)
		
		var desired_tilt = (-input_dir.x) * 0.1 + float(sliding) * 0.1
		if wallrunning:
			desired_tilt = (input_dir.x) * 0.1
		
		head.rotation.z = lerp(head.rotation.z, desired_tilt, delta * 7.0) # cos(t_bob * BOB_FREQ / 4) * BOB_AMP/2

	move_and_slide()
		
	if health < 0:
		is_dead = true
		if Input.is_action_just_pressed("reset"):
			get_tree().reload_current_scene()
		

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	
	pos.y = sin(time * data.BOB_FREQ) * data.BOB_AMP
	pos.x = cos(time * data.BOB_FREQ / 2) * data.BOB_AMP
	
	return pos