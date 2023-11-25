extends Node

var current_scene_index = 0
var current_level_node

@onready var pause_menu = $PauseMenu

@export var scenes: Array[PackedScene]
@export var home_menu_scene: PackedScene
@export var game_complete_scene: PackedScene


func _ready():
	start_level()

func start_level():
	current_level_node = scenes[current_scene_index].instantiate() as Level
	current_level_node.level_complete.connect(_on_level_complete)
	add_child(current_level_node)
	# Ensure the pause menu remains on top
	remove_child(pause_menu)
	add_child(pause_menu)

func reload_current_scene():
	remove_child(current_level_node)
	current_level_node.queue_free()
	start_level()

func _input(event):
	if event.is_action_pressed("pause"):
		pause_menu.visible = true
		get_tree().paused = true

func resume_game():
	pause_menu.visible = false
	get_tree().paused = false


func exit_to_menu():
	get_tree().change_scene_to_packed(home_menu_scene)
	get_tree().paused = false


func on_game_complete():
	get_tree().change_scene_to_packed(game_complete_scene)


func _on_level_complete():
	current_scene_index += 1
	if current_scene_index >= scenes.size():
		on_game_complete()
	else:
		reload_current_scene()