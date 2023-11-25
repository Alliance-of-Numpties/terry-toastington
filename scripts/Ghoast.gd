extends Area2D


func _on_body_entered(body:Node2D):
	if body is Player:
		body.kill()

func kill():
	print("BOO")
	# Free the parent path follow node, not just the ghoast
	get_parent().queue_free()
