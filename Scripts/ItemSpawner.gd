extends Node

@export var item_parent: Node3D
@export var item_templates: Array[PackedScene]

## Handling the item spawn timer event trigger.
func _spawn_pickup_item() -> void:
	var item = item_templates.pick_random().instantiate()
	item_parent.add_child(item)
	
	item.global_position.x = randf_range(-40.0, 40.0)
	item.global_position.y = randf_range(2.0, 6.0)
	item.global_position.z = randf_range(-40.0, 40.0)
	
	item.rotation.x = randf_range(0, PI * 2.0)
	item.rotation.y = randf_range(0, PI * 2.0)
	item.rotation.z = randf_range(0, PI * 2.0)
