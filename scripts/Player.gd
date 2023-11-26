extends CharacterBody2D

class_name Player

signal death_start
signal death_end
signal got_jam
signal completed_level

@export var speed = 500.0
@export var jump_velocity = -1000.0
@export var jam_points = 0
var target_points = 1
@export var wall_slide_speed_limit = 100

@export var hand: RemoteTransform2D
@export var gun: Gun = null

@export var jam_splat: Sprite2D
@export var jam_splat_curve: Curve

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_tree = $AnimationTree
@onready var model = $Model

var dead = false
var in_victory_anim = false


func _ready():
	animation_tree.active = true

func _process(_delta):
	if not jam_points:
		jam_splat.visible = false
	else:
		jam_splat.visible = true
		jam_splat.scale = Vector2(1,1) * jam_splat_curve.sample(jam_points / float(target_points))


func _physics_process(delta):
	var input_direction = Input.get_axis("left", "right")
	var input_jump = Input.is_action_just_pressed("jump")

	if dead or in_victory_anim:
		# If dead or playing the victory animation, ignore input.
		input_direction = 0
		input_jump = false
		# Stop the horizontal movement.
		velocity.x = 0
	else:
		# Handle the side-to-side movement/deceleration and animation.
		if input_direction:
			velocity.x = input_direction * speed
			animation_tree.get("parameters/playback").travel("walk")
			model.scale.x = -sign(input_direction) * abs(model.scale.x)
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			animation_tree.get("parameters/playback").travel("idle")

	# Add the gravity.
	if not is_on_floor():
		var falling = velocity.y > 0
		var falling_multiplier = 0.8
		var rising_multiplier = 1.2
		var gravity_multiplier = falling_multiplier if falling else rising_multiplier
		velocity.y += gravity * delta * gravity_multiplier
		if is_on_wall() and input_direction != 0:
			# If on a wall, limit the falling speed
			velocity.y = min(velocity.y, wall_slide_speed_limit)

	# Handle Jump.
	if input_jump:
		if is_on_floor() or is_on_wall():
			velocity.y = jump_velocity

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
	$JamPickupSound.play()


func collided_with_plate(_plate):
	if jam_points == get_tree().get_first_node_in_group("Level").target_jam_points:
		collision_layer = 0 # Disable collisions
		animation_tree.get("parameters/playback").travel("victory")
		in_victory_anim = true
		print("VICTORY")


func victory_anim_done():
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
