extends Area2D

@export var gun_scene: PackedScene

func _on_body_entered(body: Player):
	body.pickup_gun(gun_scene)
	queue_free()
