extends Node3D

@export var player: Node3D
@export var camera_node: Node3D
@export var distance: float = 10.0
@export var zoom_speed: float = 0.5
@export var rotate_speed: float = 0.001

## process
func _process(_delta: float) -> void:
	# Set the camera pivot position to the player's position.
	self.global_position = player.global_position

## input
func _input(event: InputEvent) -> void:
	# When the "Do Rotate" key is pressed, capture the mouse to enable camera rotation.
	# When the key is released, make the mouse cursor visible.
	if event.is_action_pressed("Do Rotate"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_released("Do Rotate"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# When "Zoom" input is detected, adjust the local position of the camera object,
	# which is a child of the camera pivot node.
	if event.is_action("Zoom In"):
		camera_node.position.z -= zoom_speed
	if event.is_action("Zoom Out"):
		camera_node.position.z += zoom_speed
	
	# While the mouse is captured, if mouse movement input is detected, rotate the camera pivot node.
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		self.global_rotate(Vector3.UP, event.relative.x * -rotate_speed)
		self.global_rotate(camera_node.global_transform.basis.x, event.relative.y * -rotate_speed)
