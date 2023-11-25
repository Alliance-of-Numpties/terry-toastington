extends Node2D

@export var target_jam_points = 15


func _on_player_spawner_spawned_player():
	var player = get_tree().get_first_node_in_group("Player")
	player.death_end.connect(_on_player_death)


func _on_player_death():
	get_parent().reload_current_scene()
