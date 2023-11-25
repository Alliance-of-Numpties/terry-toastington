extends Node

@export var game_scene: PackedScene


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
