extends CharacterBody2D

class_name Player

signal death

@export var speed = 500.0
@export var jump_velocity = -900.0
@export var jam_points = 0
@export var wall_slide_speed_limit = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if not is_on_wall():
			velocity.y += gravity * delta
		else:
			velocity.y += gravity * delta
			# Continue jumping with regular gravity if still moving up,
			# otherwise use the wall slide gravity modifier.
			velocity.y = min(velocity.y, wall_slide_speed_limit)

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
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()


func collided_with_jam(jam):
	jam_points += 1
	print(str(self) + " jam points: " + str(jam_points))
	jam.queue_free()

func kill():
	print("OW")
	death.emit()