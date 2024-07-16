extends Area2D

class_name Bullet

enum OWNER {
	PLAYER,
	ENEMY
}
@export var Owner : OWNER
@export var Damage = 1
@export var Speed = 1000
var Direction = Vector2.ZERO

func _ready():
	Direction = Helper.DegreesToUnitCircle(rotation_degrees)
	if Owner == OWNER.PLAYER:
		set_collision_layer_value(Helper.GetPlayerBulletLayer(), true)
	else:
		set_collision_layer_value(Helper.GetEnemyBulletLayer(), true)


func _process(delta):
	global_position += Direction * delta * Speed


func _on_timer_timeout():
	queue_free()

func GetDamage():
	return Damage
