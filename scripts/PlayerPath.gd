extends Node2D

class_name PlayerPath

@export var player: CharacterBody2D

class TimedPoint:
	var time: float
	var position: Vector2

	func _init(_time: float, _position: Vector2):
		time = _time
		position = _position

class Recording:
	var start_time: float
	var points: Array[TimedPoint]

	func _init(_start_time: float, _points: Array[TimedPoint]):
		start_time = _start_time
		points = _points

	func get_position_for_time(time: float) -> Vector2:
		# Wildly inefficient for now, but nevermind...
		var prev_point: TimedPoint = null
		var next_point: TimedPoint = null
		for point in points:
			if point.time < time:
				prev_point = point
			else:
				next_point = point
				break
		if prev_point == null:
			return next_point.position
		if next_point == null:
			return prev_point.position
		var time_delta = next_point.time - prev_point.time
		var time_progress = (time - prev_point.time) / time_delta
		return prev_point.position.lerp(next_point.position, time_progress)

var recording = null

func _ready():
	recording = Recording.new(Time.get_ticks_msec(), [TimedPoint.new(0.0, player.position)])
	get_tree().create_timer(3.0).timeout.connect(_on_player_finish_level)

func _physics_process(_delta):
	if recording != null:
		var new_point = TimedPoint.new(Time.get_ticks_msec() - recording.start_time, player.position)
		recording.points.append(new_point)

func _on_player_finish_level():
	for child in get_children():
		if child is PlayerPathFollow:
			child.set_process_mode(Node.PROCESS_MODE_INHERIT)
			child.visible = true
			child.recording = recording
			child.start_time = Time.get_ticks_msec()
	recording = null
