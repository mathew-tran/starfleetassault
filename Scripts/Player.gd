extends Area2D

class_name Player

var MoveSpeed = 500
var BoostSpeedModifier = 1000
@onready var SmokeParticle = $SmokeParticles
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

func Move(delta):
	var targetPosition = get_global_mouse_position()
	var direction = (targetPosition - global_position).normalized()
	rotation_degrees = rad_to_deg(direction.angle())

	if Input.is_action_pressed("stop"):
		return

	if targetPosition.distance_to(global_position) < MoveSpeed / 5:
		return

	var SpeedToMove = MoveSpeed
	if HasSpeedBoost():
		SpeedToMove += BoostSpeedModifier
	global_position += direction * SpeedToMove * delta


func _input(event):
	if CanPlayerMove() == false:
		return

	if event.is_action_pressed("left_click"):
		Shoot()
	if event.is_action_pressed("right_click"):
		if CanBoost():
			$SpeedTimer.start()
			scale = Vector2(1,.5)

func Shoot():
	for cannon in Cannons:
		var instance = BulletClass.instantiate()
		instance.global_position = cannon.global_position
		instance.rotation_degrees = rotation_degrees
		Groups.GetBullets().add_child(instance)

func CanBoost():
	return $SpeedTimer.time_left == 0.0 and $SpeedCooldownTimer.time_left == 0.0

func HasSpeedBoost():
	return $SpeedTimer.time_left != 0.0

func _on_speed_timer_timeout():
	modulate = Color.DARK_GRAY
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.LIGHT_GRAY, $SpeedCooldownTimer.wait_time)

	$SpeedCooldownTimer.start()
	scale = Vector2(1,.7)



func _on_speed_cooldown_timer_timeout():
	scale = Vector2(1,1)
	modulate = Color.WHITE


func _on_area_entered(area):
	if area.has_method("GetDamage"):
		if bHasTakenHit == false:
			Health.TakeDamage(area.GetDamage())
