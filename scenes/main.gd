extends Node2D

var current_scene


func _ready():
	var level1_scene = load("res://scenes/level1.tscn")
	current_scene = level1_scene
	print(current_scene)
	add_child(current_scene.instantiate())


func reload_current_scene():
	var current = get_child(0)
	remove_child(current)
	current.queue_free()
	add_child(current_scene.instantiate())
