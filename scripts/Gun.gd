extends Node2D

class_name Gun

@export var player: CharacterBody2D # Used to determine where to add the bullets in the heirarchy
@export var bullet_scene: PackedScene
@export var bullets = 5
@export var bullet_speed = 1000

func fire(direction: Vector2):
	if bullets > 0:
		bullets -= 1
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.velocity = direction * bullet_speed
		player.add_sibling(bullet)
