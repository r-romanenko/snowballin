extends Area3D

@export_file("*.tscn") var NEXT_LEVEL: String = ""
@export var required_energy = 20

func _on_body_entered(body: RigidBody3D) -> void:
	if body.name == "Player":
		var ball_scale = body.scale.length() # size based on scale
		var ball_speed = body.linear_velocity.length()

		if ball_scale * ball_speed >= required_energy:
			var current_scene_path = get_tree().current_scene.get_scene_file_path()
			print("Current scene path: ", current_scene_path)
			if current_scene_path == "res://level_02.tscn":
				get_tree().change_scene_to_file("res://EndGame.tscn")
			else:
				call_deferred("_change_scene")

		else:
			call_deferred("_reset_level")

func _change_scene() -> void:
	get_tree().change_scene_to_file(NEXT_LEVEL)

func _reset_level() -> void:
	get_tree().reload_current_scene()
