extends CharacterBody2D

func on_hit(obj):
	if "kill" in obj:
		obj.kill()
	queue_free()


func _physics_process(_delta):
	move_and_slide()