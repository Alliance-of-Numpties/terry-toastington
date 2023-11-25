extends StaticBody2D


func _on_area_2d_body_entered(penetrator):
	penetrator.collided_with_plate(self)
