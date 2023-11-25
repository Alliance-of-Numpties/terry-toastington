extends Node2D


func get_bar():
	return get_tree().get_first_node_in_group("PointsBar")


func _ready():
	get_bar().value = 0
	get_bar().max_value = get_tree().get_first_node_in_group("Level").target_jam_points


func _on_player_got_jam():
	var player = get_tree().get_first_node_in_group("Player")
	get_bar().value = player.jam_points
