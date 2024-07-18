extends CharacterBody2D

class_name Player

var MoveSpeed = 500
var BoostSpeedModifier = 1000

@onready var SmokeParticle = $SmokeParticles
@onready var SpeedSmokeParticle = $SmokeParticles2
@onready var Sprite = $Sprite2D

var Cannons : Array[Node2D]

var BulletClass = preload("res://Prefabs/Bullets/BaseBullet.tscn")
var ExplodeFXClass = preload("res://Prefabs/FX/ExplodeParticle.tscn")

var Health : HealthComponent

var bCanMove = true
var bHasTakenHit = false

func GetHealthComponent():
	return Health


func _ready():
	Cannons.append($Cannon1)
	Cannons.append($Cannon2)

	Health = $HealthComponent as HealthComponent
	Health.Setup()
	Health.OnTakeDamage.connect(OnTakeDamage)
	Health.OnDeath.connect(OnDeath)

func OnTakeDamage(healthComponent):
	bHasTakenHit = true
	var tween = get_tree().create_tween()
	tween.tween_property(Sprite, "modulate", Color.RED, .1)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property(Sprite, "modulate", Color.WHITE, .1)
	await tween.finished
	bHasTakenHit = false

func OnDeath(healthComponent):
	bCanMove = false
	visible = false
	var instance = ExplodeFXClass.instantiate()
	instance.global_position = global_position
	Groups.GetBullets().add_child(instance)
	pass

func CanPlayerMove():
	return bCanMove == true and bHasTakenHit == false

func _physics_process(delta):
	if CanPlayerMove() == false:
		return

	Move(delta)
	SmokeParticle.emitting = true
	move_and_slide()

func Move(delta):
	var targetPosition = get_global_mouse_position()
	var direction = (targetPosition - global_position).normalized()
	rotation_degrees = rad_to_deg(direction.angle())

	if IsStopping(targetPosition):
		velocity *= .9


	var SpeedToMove = MoveSpeed
	if HasSpeedBoost():
		SpeedToMove += BoostSpeedModifier
		SpeedSmokeParticle.emitting = true
	else:
		SpeedSmokeParticle.emitting = false

	velocity += direction * SpeedToMove * delta

	if velocity.length() > GetMaxSpeed():
		velocity = velocity.normalized() * GetMaxSpeed()

func GetMaxSpeed():
	if HasSpeedBoost():
		return 1000
	else:
		return 500
func IsStopping(targetPosition):
	return Input.is_action_pressed("stop") or targetPosition.distance_to(global_position) < MoveSpeed / 10

func _input(event):
	if CanPlayerMove() == false:
		return

	if event.is_action_pressed("left_click"):
		Shoot()
	if event.is_action_pressed("right_click"):
		$SpeedTimer.start()

	if event.is_action_released("right_click"):
		$SpeedTimer.stop()

func Shoot():
	for cannon in Cannons:
		var instance = BulletClass.instantiate()
		instance.global_position = cannon.global_position
		instance.rotation_degrees = rotation_degrees
		Groups.GetBullets().add_child(instance)

func CanBoost():
	return $SpeedTimer.time_left == 0.0

func HasSpeedBoost():
	return $SpeedTimer.time_left != 0.0




func _on_area_2d_area_entered(area):
	if area.has_method("GetDamage"):
		if bHasTakenHit == false:
			Health.TakeDamage(area.GetDamage())
