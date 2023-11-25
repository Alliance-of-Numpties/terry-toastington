extends Node2D

class_name Gun

signal empty_clip

@export var bullet_scene: PackedScene
@export var bullets = 5
@export var bullet_speed = 1000

func fire(direction: Vector2):
	if bullets > 0:
		bullets -= 1
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.velocity = direction * bullet_speed
		get_parent().add_sibling(bullet)
		if bullets == 0:
			empty_clip.emit()
