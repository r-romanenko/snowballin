extends Area3D

@export_file("*.tscn") var NEXT_LEVEL: String = ""


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Ball":
		call_deferred("_change_scene")

func _change_scene() -> void:
	await get_tree().change_scene_to_file(NEXT_LEVEL)
