extends Node

@export var remain_seconds: int = 60 * 3
@export var player: Node3D

@onready var label_gameplay_timer: Label = $"../UI/LabelGameplayTimer"
@onready var label_game_over: Label = $"../UI/LabelGameOver"

## Ready
func _ready() -> void:
	set_gameplay_timer_label_text()

## Handling the gameplay timer event.
func on_gameplay_timer_timeout() -> void:
	remain_seconds -= 1
	
	if remain_seconds < 0:
		label_game_over.show()
		player.is_sizeup_enabled = false
	else:
		set_gameplay_timer_label_text()

## Set the remaining gameplay time text.
func set_gameplay_timer_label_text() -> void:
	var seconds = remain_seconds % 60
	var minutes = (int)(remain_seconds / 60.0) % 60
	var timer_string = "%02d:%02d" % [minutes, seconds]
	
	label_gameplay_timer.text = timer_string

## reload game scene
func restart_game() -> void:
	get_tree().change_scene_to_file("res://Scenes/GameScene.tscn")
