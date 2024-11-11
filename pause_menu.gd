extends Control

func _ready():
	$AnimationPlayer.play("RESET")
	$Mechanics.visible = false
	visible = false  # Start with the pause menu hidden

func resume():
	visible = false
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	visible = true
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("g"):
		$Mechanics.visible = false 
		resume()
		
	if Input.is_action_just_pressed("escape") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused == true:
		resume()
	
func _on_resume_pressed() -> void:
	if not visible:
		return  # Skip execution if the pause menu is not visible

	resume()

func _on_restart_pressed() -> void:
	if not visible:
		return  # Skip execution if the pause menu is not visible
	pause()
	$Mechanics.visible = true  # Show the pause menu
	#resume()
	#get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	if not visible:
		return  # Skip execution if the pause menu is not visible

	get_tree().quit()

func _process(delta: float) -> void:
	testEsc()
