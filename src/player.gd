class_name Player
extends CharacterBody3D

@export var data: MovementData

@onready var health: float = data.MAX_HEALTH
var is_dead:bool = false

var speed: float
var jumps:int

var wallrunning := false
var wall_normal

var sliding:bool = false
var slide_vec:Vector3 = Vector3.ZERO
var slide_vec_off:Vector3

var weapon_idx:int = 0
var gun: Node

var t_bob:float = 0.0

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var collision = $CollisionShape3D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	speed = data.WALK_SPEED
	
	_reload_weapon_swap()
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if !is_dead:
			head.rotate_y(-event.relative.x * data.SENSITIVITY)
			camera.rotate_x(-event.relative.y * data.SENSITIVITY)
		
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if weapon_idx < $Head/Camera3D/Hand.get_child_count() - 1:
					weapon_idx += 1
				else:
					weapon_idx = 0
				
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if weapon_idx > 0:
					weapon_idx -= 1
				else:
					weapon_idx = $Head/Camera3D/Hand.get_child_count() - 1

func _physics_process(delta: float) -> void:
	if !is_dead:
	
		_reload_weapon_swap()
	
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= data.GRAVITY * delta
		else:
			jumps = 0
	
	
		# Handle Jump.
		if (Input.is_action_just_pressed("jump") and !jumps > data.BONUS_JUMPS) || (Input.is_action_pressed("jump") and !jumps > 0) && !wallrunning:
			velocity.y = data.JUMP_VELOCITY
			jumps += 1

		var input_dir := Input.get_vector("left", "right", "up", "down")
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if is_on_floor():
			if direction:
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed
				#velocity.x = lerp(velocity.x, direction.x * speed, delta * data.GROUND_ACCEL) # velocity.x = direction.x * speed
				#velocity.z = lerp(velocity.z, direction.z * speed, delta * data.GROUND_ACCEL) # velocity.z = direction.z * speed
			else:
				velocity.x = lerp(velocity.x, direction.x * speed, delta * data.GROUND_DECEL)
				velocity.z = lerp(velocity.z, direction.z * speed, delta * data.GROUND_DECEL)
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * data.AIR_LERP)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * data.AIR_LERP)
		
		if is_on_wall_only():
			if input_dir.y != 0 && input_dir.x != 0:
				wall_normal = get_slide_collision(0)
				wallrunning = true
				
				velocity.y = clamp(velocity.y, -.5, 1000000)
				
				if Input.is_action_pressed("jump"):
					velocity = wall_normal.get_normal() * speed
					velocity.y = data.JUMP_VELOCITY
		else:
			wallrunning = false
		
		if Input.is_action_pressed("slide") && is_on_floor():
			if !sliding:
				if input_dir != Vector2.ZERO:
					slide_vec = direction
				else:
					slide_vec = (head.transform.basis * Vector3(0, 0, -1)).normalized()
			sliding = true
		elif Input.is_action_just_released("slide") && !$SlideCast.is_colliding():
			sliding = false
		
		if sliding:
			collision.shape.height = move_toward(collision.shape.height, 1.0,delta * 9.0)
			head.position.y = lerp(head.position.y, 0.0, delta * 8.0)
			
			var slide_speed:float = data.SLIDE_SPEED
			if speed/1.1 > data.SLIDE_SPEED:
				slide_speed = speed
			
			slide_speed += get_floor_angle()*0.1
			
			# Slide force
			velocity.x = slide_vec.x * (slide_speed)
			velocity.z = slide_vec.z * (slide_speed)
			
			if is_on_floor():
				speed = slide_speed
			
			
			if Input.is_action_pressed("jump") && is_on_floor():
				sliding = false
				speed = slide_speed + 1
			
		else:
			collision.shape.height = lerp(collision.shape.height, 2.0, delta * 9.0)
			head.position.y = lerp(head.position.y, .5, delta * 8.0)
		
		if is_on_floor() && !sliding:
			speed = move_toward(speed, data.WALK_SPEED, delta * 20.0)
		
		if gun.has_method("shoot"):
			gun.shoot($Head/Camera3D/Aimcast)
		
		
		t_bob += delta * velocity.length() * (float(is_on_floor())) * float(!is_on_wall()) * float(!sliding)
		camera.transform.origin = _headbob(t_bob)
		
		#var desired_tilt = cos(t_bob * data.BOB_FREQ / 2) * data.BOB_AMP/2
		var desired_tilt = ((-input_dir.x) * data.VIEW_TILT) * float(!sliding) + float(sliding) * 0.1
		if wallrunning:
			desired_tilt = (input_dir.x) * 0.1
		
		
		head.rotation.z = lerp(head.rotation.z, desired_tilt, delta * data.TILT_LERP)

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

func _reload_weapon_swap():
	for c in $Head/Camera3D/Hand.get_child_count():
		var child = $Head/Camera3D/Hand.get_child(c)
		child.hide()
	gun = $Head/Camera3D/Hand.get_child(weapon_idx)
	gun.show()
	
