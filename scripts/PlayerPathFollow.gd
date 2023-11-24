extends PathFollow2D

class_name PlayerPathFollow

var recording: PlayerPath.Recording = null
var start_time: int = 0

func _physics_process(_delta):
    if recording != null:
        position = recording.get_position_for_time(Time.get_ticks_msec() - start_time)