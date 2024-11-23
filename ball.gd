extends RigidBody3D

@export var rolling_force = 40
@export var jump_impulse = 30

@export var growth_rate = 0.1  # How fast the ball grows per second
@export var max_scale = 10.0   # Maximum size multiplier


@onready var collision_shape = $CollisionShape3D
@onready var model = $Model
@onready var floor_check = $FloorCheck

func _ready():
	$Marker3D.set_as_top_level(true)
	$FloorCheck.set_as_top_level(true)

func _physics_process(delta: float) -> void:
	# Growth logic
	var current_scale = collision_shape.scale.x
	if current_scale < max_scale:
		var new_scale = current_scale + (growth_rate * delta)
		new_scale = min(new_scale, max_scale)
		var new_scale_vec = Vector3(new_scale, new_scale, new_scale)
		
		# Scale both collision shape and visual model
		collision_shape.scale = new_scale_vec
		model.scale = new_scale_vec
		
		# Adjust floor check position based on ball size
		floor_check.position.y = -current_scale
		
		#print("Current scale: ", new_scale)  # Debug print

	var old_camera_pos = $Marker3D.global_transform.origin
	var ball_pos = global_transform.origin
	var new_camera_pos = lerp(old_camera_pos, ball_pos, 0.1)
	$Marker3D.global_transform.origin = new_camera_pos
	
	$FloorCheck.global_transform.origin = global_transform.origin
	
	if Input.is_action_pressed("forward"):
		angular_velocity.x -= rolling_force * delta
	elif Input.is_action_pressed("back"):
		angular_velocity.x += rolling_force * delta
	if Input.is_action_pressed("left"):
		angular_velocity.z += rolling_force * delta
	elif Input.is_action_pressed("right"):
		angular_velocity.z -= rolling_force * delta
		
	# var is_onfloor = $FloorCheck.is_colliding()
	if !$FloorCheck.is_colliding():
		$Rolling.stop()
	
	if $FloorCheck.is_colliding(): #and is_onfloor:
		# make sound effect
		if !$Rolling.playing:
			$Rolling.play()
		
		if Input.is_action_just_pressed("jump"):
			#scales the jump to jump a little higher when ball is bigger
			apply_central_impulse(Vector3.UP * jump_impulse*current_scale*1)
