extends RigidBody3D

@export var camera_node: Camera3D
@export var move_force: float = 200.0
#from other project
@onready var attachments: Node3D = $Attachments
@onready var player_collision: CollisionShape3D = $PlayerCollision
#@onready var label_item_count: Label = $"../UI/Information/LabelItemCount"
#@onready var label_size: Label = $"../UI/Information/LabelSize"
@onready var collision_shape = $CollisionShape3D

@onready var model = $snowball_model
@onready var floor_check = $FloorCheck

var player_input: Vector2 = Vector2.ZERO
var is_sizeup_enabled: bool = true
var pickup_count: int = 0

## startup
func _ready() -> void:
	player_collision.shape.radius = 0.5

## physics process

@export var rolling_force = 40
@export var jump_impulse = 30

@export var growth_rate = 0.1  # How fast the ball grows per second
@export var max_scale = 10.0   # Maximum size multiplier

	
#@onready var collision_shape = $CollisionShape3D
#@onready var model = $Model
#@onready var floor_check = $FloorCheck


func _physics_process(delta: float) -> void:

	#var old_camera_pos = $Marker3D.global_transform.origin
	#var ball_pos = global_transform.origin
	#var new_camera_pos = lerp(old_camera_pos, ball_pos, 0.1)
	#$Marker3D.global_transform.origin = new_camera_pos
	#
	if Input.is_action_pressed("forward"):
		angular_velocity.x -= rolling_force * delta
	elif Input.is_action_pressed("back"):
		angular_velocity.x += rolling_force * delta
	if Input.is_action_pressed("left"):
		angular_velocity.z += rolling_force * delta
	elif Input.is_action_pressed("right"):
		angular_velocity.z -= rolling_force * delta
		#
	## var is_onfloor = $FloorCheck.is_colliding()
	#if !$FloorCheck.is_colliding():
		#$Rolling.stop()
	#
	#if $FloorCheck.is_colliding(): #and is_onfloor:
		## make sound effect
		#if !$Rolling.playing:
			#$Rolling.play()
		#
		#if Input.is_action_just_pressed("jump"):
			##scales the jump to jump a little higher when ball is bigger
			#apply_central_impulse(Vector3.UP * jump_impulse*current_scale*1)

## get the forward vector of the camera projected onto a plane facing upward.
func _get_projected_camera_forward() -> Vector3:
	var camera_forward: Vector3 = -camera_node.global_basis.z
	var plane: Plane = Plane.PLANE_XZ
	# Since the magnitude of the projected vector may not be 1 depending on the camera's angle,
	# normalize it to ensure its magnitude is 1 before performing calculations.
	camera_forward = (plane.project(camera_forward) * 100.0).normalized()
	return camera_forward

## get the right vector of the camera
func _get_camera_right() -> Vector3:
	return camera_node.global_basis.x

## when collision detected
func _on_body_entered(other_body: Node) -> void:
	if other_body.has_meta("is_pickup_item") and is_sizeup_enabled:
		var is_pickup_item: bool = other_body.get_meta("is_pickup_item")
		if is_pickup_item:
			var increase_size: float = other_body.increase_size
			other_body.attach_to_player(attachments)
			increase_size*=10
			_increase_player_collision_scale(increase_size)
			_increase_player_model_scale(increase_size*10)

## increase player's collision shape size
func _increase_player_collision_scale(size: float) -> void:
	player_collision.shape.radius += size
	pickup_count += 1
	
func _increase_player_model_scale(size:float)->void:
	# Growth logic
	var current_scale = collision_shape.scale.x
	if current_scale < max_scale:
		var new_scale = current_scale + (growth_rate)
		new_scale = min(new_scale, max_scale)
		var new_scale_vec = Vector3(new_scale, new_scale, new_scale)
		
		# Scale both collision shape and visual model
		collision_shape.scale = new_scale_vec
		model.scale = new_scale_vec
		
		# Adjust floor check position based on ball size
		floor_check.position.y = -current_scale
		
	# update information text
	#label_item_count.text = "Pickup Item Count: %d" % pickup_count
	#label_size.text = "Size: %.3fm" % player_collision.shape.radius
