extends Area2D

class_name Player

var MoveSpeed = 500
var BoostSpeedModifier = 1000
@onready var SmokeParticle = $SmokeParticles

var Cannons : Array[Node2D]

var BulletClass = preload("res://Prefabs/Bullets/BaseBullet.tscn")

var Health : HealthComponent


func _ready():
	Cannons.append($Cannon1)
	Cannons.append($Cannon2)

	Health = $HealthComponent as HealthComponent
	Health.Setup()
	Health.OnTakeDamage.connect(OnTakeDamage)
	Health.OnDeath.connect(OnDeath)

func OnTakeDamage(healthComponent):
	pass

func OnDeath(healthComponent):
	pass

func _physics_process(delta):
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
		pass
