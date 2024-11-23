extends Camera3D

@export var default_offset = Vector3(0, 2.85, 3)  # Default camera position relative to the ball
@export var ball_path: NodePath  # Path to the ball node
@export var scale_intensity = 1.0  # Multiplier for the ball's scale effect on the camera distance
@export var scale_camera = false

func _process(delta: float) -> void:
	var ball = get_node(ball_path) if ball_path else null
	if not ball:
		return  # Exit if the ball is not assigned or found

	if scale_camera:
		# Get the current scale of the ball
		var current_scale = ball.collision_shape.scale.x

		# Calculate the adjusted offset based on the ball's scale
		# The higher the scale_intensity, the farther the camera moves away
		var adjusted_offset = default_offset * (1.0 + (current_scale - 1.0) * scale_intensity)

		# Debug to see the actual values
		print("Ball Scale: ", current_scale, " | Adjusted Offset: ", adjusted_offset)

		# Smoothly move the camera to its new position
		var target_position = ball.global_transform.origin + adjusted_offset
		global_transform.origin = lerp(global_transform.origin, target_position, 0.1)
