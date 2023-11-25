extends Node

@export var spawn_marker: Node2D
@export var player_scene: PackedScene
@export var player_path_scene: PackedScene

var player: Player
var player_path: PlayerPath

signal spawned_player


func _ready():
	spawn_player.call_deferred()


func spawn_player():
	player = player_scene.instantiate() as Player
	player.global_position = spawn_marker.global_position
	add_sibling(player)

	player_path = player_path_scene.instantiate()
	player_path.player = player
	add_sibling(player_path)

	spawned_player.emit()
