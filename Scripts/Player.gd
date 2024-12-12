extends RigidBody3D

@export var camera_node: Camera3D
@export var move_force: float = 200.0
@export var rolling_force: float = 40.0
@export var jump_impulse: float = 30.0
@export var initial_size: float = 0.5
@export var size_reduction_on_attach: float = -0.15  # Amount to shrink when getting attachment
@export var growth_rate: float = 0.1
@export var max_scale: float = 10.0

@onready var attachments: Node3D = $Attachments
@onready var player_collision: CollisionShape3D = $PlayerCollision
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var model: Node3D = $snowball_model
@onready var floor_check: Node3D = $FloorCheck

var player_input: Vector2 = Vector2.ZERO
var is_sizeup_enabled: bool = true
var pickup_count: int = 0
var current_size: float

func _ready() -> void:
	current_size = initial_size
	_update_size(initial_size)

func _physics_process(delta: float) -> void:
	# Handle movement
	if Input.is_action_pressed("forward"):
		angular_velocity.x -= rolling_force * delta
	elif Input.is_action_pressed("back"):
		angular_velocity.x += rolling_force * delta
	if Input.is_action_pressed("left"):
		angular_velocity.z += rolling_force * delta
	elif Input.is_action_pressed("right"):
		angular_velocity.z -= rolling_force * delta
	
	# Handle rolling sound
	if floor_check.is_colliding():
		if !$Rolling.playing:
			$Rolling.play()
			
		# Handle jumping
		if Input.is_action_just_pressed("jump"):
			apply_central_impulse(Vector3.UP * jump_impulse * current_size)
			
		# Apply continuous growth while rolling
		if current_size < max_scale:
			_update_size(current_size + (growth_rate * delta))
	else:
		$Rolling.stop()

func _on_body_entered(other_body: Node) -> void:
	if other_body.has_meta("is_pickup_item") and is_sizeup_enabled:
		var is_pickup_item: bool = other_body.get_meta("is_pickup_item")
		if is_pickup_item:
			# First shrink the ball
			_update_size(current_size * (1.0 - size_reduction_on_attach))
			
			# Then attach the item
			other_body.attach_to_player(attachments)
			pickup_count += 1

func _update_size(new_size: float) -> void:
	current_size = clamp(new_size, initial_size, max_scale)
	
	# Update collision shape
	player_collision.shape.radius = current_size
	
	# Update visual scale
	var scale_vector = Vector3(current_size, current_size, current_size)
	collision_shape.scale = scale_vector
	model.scale = scale_vector
	
	# Update floor check position based on current size
	floor_check.position.y = -current_size

func _get_projected_camera_forward() -> Vector3:
	var camera_forward: Vector3 = -camera_node.global_basis.z
	var plane: Plane = Plane.PLANE_XZ
	return (plane.project(camera_forward) * 100.0).normalized()

func _get_camera_right() -> Vector3:
	return camera_node.global_basis.x
