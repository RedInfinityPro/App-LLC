extends Area2D

@onready var toolAmountLabel = $ToolAmountLabel
var toolAmount = null
var player_inside = null
# Called when the node enters the scene tree for the first time.
func _ready():
	toolAmount = (randi() % 100)
	toolAmountLabel.text = str(toolAmount) + "%"
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _process(delta):
	if player_inside:
		if not use_tool():
			return
		else:
			player_inside.gain_health(toolAmount)

func use_tool():
	if player_inside.healthBar.value > toolAmount:
		return false
	else:
		queue_free()
		return true

func _on_body_entered(body):
	player_inside = body

func _on_body_exited(body):
	if body == player_inside:
		player_inside = null
