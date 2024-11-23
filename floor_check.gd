extends RayCast3D

@export var ball_path: NodePath
@export var scale_intensity = 1.0

func _process(delta: float) -> void:
	var ball = get_node(ball_path) if ball_path else null
	if not ball:
		print("Ball not found!")
		return  # Exit if the ball is not assigned or found

	# Access the CollisionShape3D of the ball
	var collision_shape = ball.get_node("CollisionShape3D") if ball.has_node("CollisionShape3D") else null
	if not collision_shape:
		print("CollisionShape3D not found!")
		return  # Exit if the collision shape is not found

	# Get the current scale of the ball's collision shape
	var current_scale = collision_shape.scale.y
	print("Current scale of collision shape:", current_scale)

	# Scale the RayCast3D proportionally to the ball's size
	self.scale = Vector3.ONE * current_scale * scale_intensity
	print("RayCast3D scale updated to:", self.scale)
