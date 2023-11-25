extends Node

var current_scene
var current_level_node

@onready var pause_menu = $PauseMenu

@export var scenes: Array[PackedScene]
@export var home_menu_scene: PackedScene


func _ready():
	current_scene = scenes[0]
	print(current_scene)
	start_level()

func start_level():
	current_level_node = current_scene.instantiate()
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
