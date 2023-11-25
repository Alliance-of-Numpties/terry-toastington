extends Node2D

class_name PlayerPath

@export var player: CharacterBody2D
@export var ghoast_scene: PackedScene

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

@onready var recording: Recording = Recording.new(Time.get_ticks_msec(), [TimedPoint.new(0.0, player.position)])
var timer: Timer
@export var spawn_time: float = 3.0

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timeout)
	timer.start(spawn_time)

func _physics_process(_delta):
	if recording != null:
		var new_point = TimedPoint.new(Time.get_ticks_msec() - recording.start_time, player.position)
		recording.points.append(new_point)

func spawn_child():
	var child = ghoast_scene.instantiate() as PlayerPathFollow
	child.start_time = Time.get_ticks_msec()
	child.recording = recording
	add_child(child)

func _on_timeout():
	spawn_child()
	timer.start(spawn_time)
