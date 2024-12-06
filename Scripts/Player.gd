extends RigidBody3D

@export var camera_node: Camera3D
@export var move_force: float = 200.0

@onready var attachments: Node3D = $Attachments
@onready var player_collision: CollisionShape3D = $PlayerCollision
@onready var label_item_count: Label = $"../UI/Information/LabelItemCount"
@onready var label_size: Label = $"../UI/Information/LabelSize"

var player_input: Vector2 = Vector2.ZERO
var is_sizeup_enabled: bool = true
var pickup_count: int = 0

## startup
func _ready() -> void:
	player_collision.shape.radius = 0.5

## process
func _process(_delta: float) -> void:
	# To handle physical movement, store player input values in _process,
	# and perform the actual processing in _physics_process.
	player_input.x = Input.get_axis("Left", "Right")
	player_input.y = Input.get_axis("Backward", "Forward")	

## physics process
func _physics_process(delta: float) -> void:
	var forward_dir: Vector3 = _get_projected_camera_forward()
	var right_dir: Vector3 = _get_camera_right()
	
	# Calculate the force to be applied to the ball based on player input.
	var vertical_force: Vector3 = forward_dir * player_input.y * move_force * delta
	var horizontal_force: Vector3 = right_dir * player_input.x * move_force * delta
	
	apply_central_force(vertical_force)
	apply_central_force(horizontal_force)

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
			_increase_player_scale(increase_size)

## increase player's collision shape size
func _increase_player_scale(size: float) -> void:
	player_collision.shape.radius += size
	pickup_count += 1
	
	# update information text
	label_item_count.text = "Pickup Item Count: %d" % pickup_count
	label_size.text = "Size: %.3fm" % player_collision.shape.radius
