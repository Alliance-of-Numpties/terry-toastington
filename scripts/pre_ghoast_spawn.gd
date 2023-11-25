extends Node2D

@export var ghoast_scene: PackedScene

var recording = null

func _ready():
	get_tree().create_timer(1.0).timeout.connect(_on_timeout)
	global_position = recording.points[0].position

func _on_timeout():
	var ghoast = ghoast_scene.instantiate()
	ghoast.recording = recording
	add_sibling(ghoast)
	queue_free()