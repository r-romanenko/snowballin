extends Area3D

@export_file("*.tscn") var NEXT_LEVEL: String = ""

@export var required_energy = 30


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Ball":
		var ball_scale = body.scale.length() # size based on scale
		var ball_speed = body.linear_velocity.length()
		
		if ball_scale * ball_speed >= required_energy:
			call_deferred("_change_scene")
		else:
			call_deferred("_reset_level")

func _change_scene() -> void:
	get_tree().change_scene_to_file(NEXT_LEVEL)
	
func _reset_level() -> void:
	get_tree().reload_current_scene()
