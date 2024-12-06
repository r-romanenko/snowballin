extends RigidBody3D

@export var increase_size: float = 0.0

## attach to player
func attach_to_player(target) -> void:
	# When attaching an item to the player, attach only the MeshInstance3D to the player
	# and remove the rest (such as the collision shapes).
	for child in self.get_children():
		if child is MeshInstance3D:
			child.reparent(target, true)
	
	self.queue_free()
