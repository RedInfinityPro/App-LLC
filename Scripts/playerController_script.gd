extends CharacterBody2D

var is_player: bool
@onready var gasBar = $gas_ProgressBar
@onready var healthBar = $health_ProgressBar
@export var Bullet : PackedScene
@export var speed := 150
@export var gallons_per_second := 0.01
@export var rotation_speed := 3.0
var newVelocity := Vector2.ZERO
var using_gas := false
var seedNumber = generate_uid()
# animation
var counter = 0
var angle_look = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	gasBar.max_value = 100
	gasBar.value = 100
	healthBar.max_value = 100
	healthBar.value = 100

func generate_uid():
	return str(Time.get_unix_time_from_system(), "_", randi())
	
func use_gas():
	if gasBar.value > 0:
		gasBar.value -= gallons_per_second

func gain_gas(amount_per_second):
	if gasBar.value < gasBar.max_value:
		gasBar.value += amount_per_second

func loss_health():
	if healthBar.value > 0:
		healthBar.value -= 1
	else:
		queue_free()
		
func gain_health(amount):
	healthBar.value += amount
		
func get_input(delta):
	var input_dir := Vector2.ZERO
	using_gas = false
	if gasBar.value > 0 and is_player:
		counter += 1
		if Input.is_action_pressed("Player_Up"):
			input_dir.y -= 1
			using_gas = true
		if Input.is_action_pressed("Player_Down"):
			input_dir.y += 1
			using_gas = true
		if Input.is_action_pressed("Player_Left"):
			input_dir.x -= 1
			using_gas = true
		if Input.is_action_pressed("Player_Right"):
			input_dir.x += 1
			using_gas = true
	# use oil
	if using_gas:
		use_gas()
	# move player
	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		newVelocity = input_dir * speed
		var target_rotation = input_dir.angle() + PI / 2
		rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
	else:
		newVelocity = Vector2.ZERO

func LookAtMouse():
	if is_player:
		var angle_to_mouse = get_angle_to(get_global_mouse_position())
		var angle_deg = rad_to_deg(angle_to_mouse)
		if angle_deg > -49 and angle_deg <= 36:
			angle_look = 2  # right
		elif angle_deg > 36 and angle_deg <= 142:
			angle_look = 4  # down
		elif angle_deg > -135 and angle_deg <= -49:
			angle_look = 0  # up
		else:
			angle_look = 6  # left
	
func shoot():
	if Input.is_action_just_pressed("Player_Shoot") and is_player:
		var bullet = Bullet.instantiate()
		bullet.rotation = (rotation * angle_look) - PI / 2 
		bullet.seedNumber = seedNumber
		get_parent().add_child(bullet)
		# spawn at muzzle (or player if you don’t have one yet)
		bullet.global_position = global_position

func _physics_process(delta):
	get_input(delta)
	set_velocity(newVelocity)
	move_and_slide()
	velocity = newVelocity

func _process(delta):
	shoot()
	LookAtMouse()
	# follow player
	if has_node("Camera2D"):
		$Camera2D.enabled = is_player
	# play animation
	if newVelocity != Vector2.ZERO:
		counter += 1
		# Walking animation: alternate between base frame and next frame
		var animation_offset = 0 if (counter / 10) % 2 == 0 else 1
		$AnimatedSprite2D.set_frame(angle_look + animation_offset)
	else:
		# Idle: show base directional frame
		counter = 0
		$AnimatedSprite2D.set_frame(angle_look)
