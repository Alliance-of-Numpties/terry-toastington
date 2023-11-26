extends StaticBody2D


func _on_area_2d_body_entered(penetrator):
	penetrator.collided_with_plate(self)

var player = null

func _ready():
	var level = get_parent().get_parent()
	level.all_jam_collected.connect(_on_all_jam_collected)

func _on_all_jam_collected():
	$AnimationPlayer.play("active")
