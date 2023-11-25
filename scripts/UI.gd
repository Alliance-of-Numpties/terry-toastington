extends Node2D


func get_player():
	return get_tree().get_first_node_in_group("Player")


func get_bar():
	return get_tree().get_first_node_in_group("PointsBar")


func _ready():
	get_bar().value = 0
	get_bar().max_value = get_tree().get_first_node_in_group("Level").target_jam_points


func _on_player_spawner_spawned_player():
	get_player().got_jam.connect(_on_player_got_jam)


func _on_player_got_jam():
	get_bar().value = get_player().jam_points
