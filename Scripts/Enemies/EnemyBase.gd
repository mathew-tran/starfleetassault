extends Area2D

class_name EnemyBase

var Health : HealthComponent

var TargetPosition = Vector2.ZERO
var MoveSpeed = 400

enum STATE {
	IDLE,
	MOVE,
	START_ATTACK,
	ATTACKING
}

var CurrentState = STATE.IDLE

signal StateUpdate(newState)

@export var DeathParticle : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	Health = $Health as HealthComponent
	Health.Setup()
	Health.OnTakeDamage.connect(OnTakeDamage)
	Health.OnDeath.connect(OnDeath)

func OnDeath(healthComponent):
	var instance = DeathParticle.instantiate()
	instance.global_position = global_position
	Groups.GetBullets().add_child(instance)
	queue_free()

func OnTakeDamage(healthComponent):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.DARK_RED, .1)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, .1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match CurrentState:
		STATE.IDLE:
			pass
		STATE.MOVE:
			AIMove(delta)
		STATE.START_ATTACK:
			AIAttack(delta)

func AIMove(delta):
	if global_position.distance_to(TargetPosition) < 2:
		global_position = TargetPosition
		ChangeState(STATE.IDLE)
	else:
		var direction = (TargetPosition - global_position).normalized()
		global_position += direction * delta * MoveSpeed

func AIAttack(delta):
	CurrentState = STATE.ATTACKING
	var timer = get_tree().create_timer(1)
	await timer.timeout
	ChangeState(STATE.IDLE)

func _on_area_entered(area):
	if area.has_method("GetDamage"):
		Health.TakeDamage(area.GetDamage())
		if area is Bullet:
			area.queue_free()
		print("hit")

func GetDamage():
	return 1

func Command_MoveToPosition(newPosition):
	ChangeState(STATE.MOVE)
	TargetPosition = newPosition

func Command_Attack(newPosition):
	ChangeState(STATE.START_ATTACK)
	TargetPosition = newPosition

func ChangeState(newState : STATE):
	CurrentState = newState
	StateUpdate.emit(CurrentState)
