extends Area2D

@export var speed := 3167
var velocity := Vector2.ZERO
var seedNumber = null
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	
func _process(delta):
	position += Vector2.RIGHT.rotated(rotation) * speed * delta

func _on_body_entered(body):
	if seedNumber != body.seedNumber:
		body.loss_health()
		queue_free()
		print(body.seedNumber)

func _on_body_exited(body):
	if seedNumber != body.seedNumber:
		print(body.seedNumber)
