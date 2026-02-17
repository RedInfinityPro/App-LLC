extends Camera2D
@export var speed := 5
@export var zoom_step := 0.1
@export var min_zoom := 0.5
@export var max_zoom := 3.0
var newVelocity := Vector2.ZERO
@export var rotation_speed := 0

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom += Vector2.ONE * zoom_step
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom -= Vector2.ONE * zoom_step
		# Clamp zoom so it doesn't go too far
		zoom.x = clamp(zoom.x, min_zoom, max_zoom)
		zoom.y = clamp(zoom.y, min_zoom, max_zoom)
		
func get_input(delta):
	var input_dir := Vector2.ZERO
	if enabled:
		if Input.is_action_pressed("Player_Up"):
			input_dir.y -= 1
		if Input.is_action_pressed("Player_Down"):
			input_dir.y += 1
		if Input.is_action_pressed("Player_Left"):
			input_dir.x -= 1
		if Input.is_action_pressed("Player_Right"):
			input_dir.x += 1
	# move player
	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		newVelocity = input_dir * speed
		var target_rotation = input_dir.angle() - PI / 2
		rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
	else:
		newVelocity = Vector2.ZERO

func _physics_process(delta):
	get_input(delta)
	position += newVelocity
