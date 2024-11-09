extends Area3D

@export_file("*.tscn") var NEXT_LEVEL: String = ""

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Ball":
		get_tree().change_scene(NEXT_LEVEL)
