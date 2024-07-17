extends Node

var Enemies

var PlayerReference : Player
@onready var FormTimer = $FormTimer

var EntryPathClass = preload("res://Prefabs/EntryPath/EntryPath1.tscn")
var EntryPathRef
enum PUPPET_STATE {
	INIT,
	FORM,
	IN_PROCESS,
	FORMED,
	ATTACK_ALL,
}
var CurrentState = PUPPET_STATE.INIT

func _ready():
	Enemies = Helper.GetEnemies()
	PlayerReference = Helper.GetPlayer()

	CurrentState = PUPPET_STATE.FORM
	EntryPathRef = EntryPathClass.instantiate()
	Helper.GetEntryPaths().add_child(EntryPathRef)

func _process(delta):
	match CurrentState:
		PUPPET_STATE.INIT:
			pass
		PUPPET_STATE.FORM:
			Form()
		PUPPET_STATE.IN_PROCESS:
			pass
		PUPPET_STATE.FORMED:
			Formed()
		PUPPET_STATE.ATTACK_ALL:
			AttackAll()

func Form():
	CurrentState = PUPPET_STATE.IN_PROCESS
	for enemy in Enemies.get_children():
		enemy.Command_FollowPath(EntryPathRef)

	FormTimer.wait_time = Enemies.get_child_count() * .5
	await FormTimer.timeout
	CurrentState = PUPPET_STATE.FORMED

func Formed():
	CurrentState = PUPPET_STATE.ATTACK_ALL
	pass

func AttackAll():
	CurrentState = PUPPET_STATE.IN_PROCESS
	for enemy in Enemies.get_children():
		enemy.Command_MoveToPosition(PlayerReference.global_position)
	FormTimer.wait_time = Enemies.get_child_count() * .5
	FormTimer.start()
	await FormTimer.timeout
	CurrentState = PUPPET_STATE.FORM
