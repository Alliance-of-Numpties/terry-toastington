extends Node2D

var current_scene
var current_level_node


func _ready():
	var level1_scene = load("res://scenes/level1.tscn")
	current_scene = level1_scene
	print(current_scene)
	current_level_node = current_scene.instantiate()
	add_child(current_level_node)


func reload_current_scene():
	remove_child(current_level_node)
	current_level_node.queue_free()
	current_level_node = current_scene.instantiate()
	add_child(current_level_node)
