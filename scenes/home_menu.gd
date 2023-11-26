extends Node

@export var next_scene_file: String = "res://scenes/main.tscn"


func _on_play_button_pressed():
	get_tree().change_scene_to_file(next_scene_file)
