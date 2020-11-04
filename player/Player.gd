extends KinematicBody

var direction = Vector3.FORWARD
var velocity = Vector3.ZERO
var acceleraton = 6

var vertical_velocity = 0
var gravity = 20

var movement_speed = 0
var walk_speed = 1.5
var run_speed = 5

var angular_acceleration = 7

func _input(event):
	if event is InputEventKey:
		if event.as_text() == "W" || event.as_text() == "A" || event.as_text() == "S" || event.as_text() == "D" || event.as_text() == "Space":
			if event.pressed:
				get_node("Status/" + event.as_text()).color = Color("ff6666")
			else:
				get_node("Status/" + event.as_text()).color = Color("ffffff")


func _physics_process(delta):
	if Input.is_action_pressed("forward") || Input.is_action_pressed("backward") || Input.is_action_pressed("left") || Input.is_action_pressed("right"):
		var h_rot = $Camroot/h.global_transform.basis.get_euler().y
	
		direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"),
					0,
					Input.get_action_strength("forward") - Input.get_action_strength("backward")).rotated(Vector3.UP, h_rot).normalized()
	
	
		if Input.is_action_pressed("sprint"):
			movement_speed = run_speed
		else:
			movement_speed = walk_speed
	else:
		movement_speed = 0
	
	velocity = lerp(velocity, direction * movement_speed, delta * acceleraton)

	move_and_slide(velocity + Vector3.DOWN * vertical_velocity, Vector3.UP)
	
	if is_on_floor():
		vertical_velocity += gravity * delta
	else:
		vertical_velocity = 0
	
	$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration)
