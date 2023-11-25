extends Node2D


func spawn_jam():
	var rng = RandomNumberGenerator.new()
	var jam_scene = load("res://scenes/jam.tscn")

	var spawn_points = get_tree().get_nodes_in_group("Jam Spawn Points")
	var target_spawn = spawn_points[randi() % spawn_points.size()]

	var jam_instance = jam_scene.instantiate()
	add_child(jam_instance)
	jam_instance.global_position = target_spawn.global_position


func _ready():
	spawn_jam.call_deferred()
