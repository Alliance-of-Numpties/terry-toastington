extends Node2D

class_name PlayerPathFollow

var recording: PlayerPath.Recording = null
var start_time: int = 0

func _physics_process(_delta):
	if recording != null:
		var timed_point = recording.get_point_for_time(Time.get_ticks_msec() - start_time)
		position = timed_point.position
		scale.x = sign(timed_point.x_scale) * abs(scale.x)
