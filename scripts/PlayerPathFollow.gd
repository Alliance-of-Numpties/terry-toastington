extends Node2D

class_name PlayerPathFollow

var recording: PlayerPath.Recording = null
var run_time: int = 0

func _physics_process(delta):
	if recording != null:
		run_time += delta * 1000 # msecs
		var timed_point = recording.get_point_for_time(run_time)
		position = timed_point.position
		scale.x = sign(timed_point.x_scale) * abs(scale.x)
