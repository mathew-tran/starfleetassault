extends Area2D

class_name Player

var MoveSpeed = 200
@onready var SmokeParticle = $SmokeParticles

var Cannons : Array[Node2D]

var BulletClass = preload("res://Prefabs/Bullets/BaseBullet.tscn")

func _ready():
	Cannons.append($Cannon1)
	Cannons.append($Cannon2)

func _physics_process(delta):
	Move(delta)

func Move(delta):
	var targetPosition = get_global_mouse_position()

	if targetPosition.distance_to(global_position) < MoveSpeed / 5:
		return

	var direction = (targetPosition - global_position).normalized()
	rotation_degrees = rad_to_deg(direction.angle())
	global_position += direction * MoveSpeed * delta
	SmokeParticle.emitting = true

func _input(event):
	if event.is_action_pressed("left_click"):
		Shoot()

func Shoot():
	for cannon in Cannons:
		var instance = BulletClass.instantiate()
		instance.global_position = cannon.global_position
		instance.rotation_degrees = rotation_degrees
		Groups.GetBullets().add_child(instance)
