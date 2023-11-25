extends Control

@export var main_menu_scene: PackedScene

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_packed(main_menu_scene)
