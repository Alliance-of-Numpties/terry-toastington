extends Node2D


func choose_random(list):
	return list[randi() % list.size()]


func spawn_jam():
	var jam_scene = load("res://scenes/jam.tscn")
	var player = get_tree().get_first_node_in_group("Player")

	var spawn_points = get_tree().get_nodes_in_group("Jam Spawn Points")
	var target_spawn = choose_random(spawn_points)

	while player.global_position.distance_to(target_spawn.global_position) < 100:
		target_spawn = choose_random(spawn_points)

	var jam_instance = jam_scene.instantiate()
	add_sibling(jam_instance)
	jam_instance.global_position = target_spawn.global_position


func _ready():
	spawn_jam.call_deferred()


func _on_player_got_jam():
	spawn_jam.call_deferred()
