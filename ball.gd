extends RigidBody3D

@export var rolling_force = 40
@export var jump_impulse = 30

func _ready():
	$Marker3D.set_as_top_level(true)
	$FloorCheck.set_as_top_level(true)

func _physics_process(delta: float) -> void:
	var old_camera_pos = $Marker3D.global_transform.origin
	var ball_pos = global_transform.origin
	var new_camera_pos = lerp(old_camera_pos,ball_pos,0.1)
	$Marker3D.global_transform.origin = new_camera_pos
	
	$FloorCheck.global_transform.origin = global_transform.origin

	
	if Input.is_action_pressed("forward"):
		angular_velocity.x -= rolling_force*delta
	elif Input.is_action_pressed("back"):
		angular_velocity.x += rolling_force*delta
	if Input.is_action_pressed("left"):
		angular_velocity.z += rolling_force*delta
	elif Input.is_action_pressed("right"):
		angular_velocity.z -= rolling_force*delta
	var is_onfloor = $FloorCheck.is_colliding()
	if Input.is_action_just_pressed("jump") and is_onfloor:
		apply_central_impulse(Vector3.UP*jump_impulse)
