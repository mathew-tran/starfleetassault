extends Area2D

class_name Bullet

@export var Speed = 1000
var Direction = Vector2.ZERO

func _ready():
	Direction = Helper.DegreesToUnitCircle(rotation_degrees)

func _process(delta):
	global_position += Direction * delta * Speed


func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.
