extends Node

class_name Level

signal all_jam_collected
signal level_complete
signal restart_level

@export var target_jam_points = 3

func _on_player_spawner_spawned_player():
	var player = get_tree().get_first_node_in_group("Player")
	player.death_end.connect(_on_player_death)
	player.completed_level.connect(func(): level_complete.emit())
	player.got_jam.connect(_on_player_pickup_jam)
	player.target_points = target_jam_points


func _on_player_death():
	restart_level.emit()


func _on_player_pickup_jam():
	var player = get_tree().get_first_node_in_group("Player")
	if player.jam_points >= target_jam_points:
		all_jam_collected.emit()
