extends Area2D

class_name EnemyBase

var Health : HealthComponent

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
	pass


func _on_area_entered(area):
	if area.has_method("GetDamage"):
		Health.TakeDamage(area.GetDamage())
		if area is Bullet:
			area.queue_free()
		print("hit")

func GetDamage():
	return 1
