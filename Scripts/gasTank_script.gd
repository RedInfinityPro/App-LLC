extends Area2D

@onready var gasBar = $gas_ProgressBar
@export var gas_per_second := 5
var player_inside = null
# Called when the node enters the scene tree for the first time.
func _ready():
	gasBar.max_value = 100
	gasBar.value = 100
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _process(delta):
	if player_inside:
		if not use_gas(delta):
			return
		player_inside.gain_gas(gas_per_second * delta)

func use_gas(delta) -> bool:
	if player_inside.gasBar.value >= 100:
		return false

	if gasBar.value > 0:
		gasBar.value -= gas_per_second * delta
		return true
	else:
		queue_free()
		return false

func _on_body_entered(body):
	player_inside = body

func _on_body_exited(body):
	if body == player_inside:
		player_inside = null
