extends CharacterBody2D

class_name Player

signal death_start
signal death_end
signal got_jam
signal completed_level

@export var speed = 500.0
@export var jump_velocity = -1000.0
@export var jam_points = 0
@export var wall_slide_speed_limit = 100

@export var hand: RemoteTransform2D
@export var gun: Gun = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_tree = $AnimationTree
@onready var model = $Model

var dead = false


func _ready():
	animation_tree.active = true


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if not is_on_wall():
			var falling = velocity.y > 0
			var falling_multiplier = 0.8
			var rising_multiplier = 1.2
			var gravity_multiplier = falling_multiplier if falling else rising_multiplier
			velocity.y += gravity * delta * gravity_multiplier
		else:
			velocity.y += gravity * delta
			# Continue jumping with regular gravity if still moving up,
			# otherwise use the wall slide gravity modifier.
			velocity.y = min(velocity.y, wall_slide_speed_limit)

	if dead:
		velocity.x = 0
	else:
		# Handle Jump.
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y = jump_velocity
			elif is_on_wall():
				velocity.y = jump_velocity

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed
			animation_tree.get("parameters/playback").travel("walk")
			model.scale.x = -sign(direction) * abs(model.scale.x)
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			animation_tree.get("parameters/playback").travel("idle")

	move_and_slide()


func _input(event):
	if dead:
		return

	if event.is_action_pressed("shoot") and gun != null:
		print("FIRE")
		gun.fire((get_global_mouse_position() - gun.global_position).normalized())


func collided_with_jam(jam):
	jam_points += 1
	print(str(self) + " jam points: " + str(jam_points))
	jam.queue_free()
	got_jam.emit()


func collided_with_plate(plate):
	if jam_points == get_tree().get_first_node_in_group("Level").target_jam_points:
		completed_level.emit()


func pickup_gun(new_gun: PackedScene):
	if gun != null:
		gun.queue_free()
	gun = new_gun.instantiate()
	gun.position = Vector2.ZERO
	gun.rotation = 0
	add_child(gun)
	hand.remote_path = hand.get_path_to(gun)
	gun.empty_clip.connect(drop_gun)


func drop_gun():
	gun.queue_free()
	gun = null
	hand.remote_path = NodePath("")


func reached_finish_line():
	get_tree().change_scene_to_file("res://scenes/home_menu.tscn")


func kill():
	print("OW")
	animation_tree.get("parameters/playback").travel("death")
	death_start.emit()
	dead = true


func death_anim_done():
	print("DEAD")
	death_end.emit()
