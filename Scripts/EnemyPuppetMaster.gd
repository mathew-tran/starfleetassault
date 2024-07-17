extends Node

var Enemies

var PlayerReference : Player
@onready var FormTimer = $FormTimer

func _ready():
	Enemies = Helper.GetEnemies()
	PlayerReference = Helper.GetPlayer()

	for enemy in Enemies.get_children():
		enemy.Command_MoveToPosition(PlayerReference.global_position)

	FormTimer.wait_time = Enemies.get_child_count() * .5
	FormTimer.start()
	await FormTimer.timeout
	for enemy in Enemies.get_children():
		enemy.Command_Attack(PlayerReference.global_position)
