extends HBoxContainer

var LifeUIElement = preload("res://Prefabs/UI/LifeUI.tscn")
func _ready():
	for child in get_children():
		child.queue_free()

	var healthComponent = Helper.GetPlayer().GetHealthComponent()
	healthComponent.OnTakeDamage.connect(OnTakeDamage)
	healthComponent.OnDeath.connect(OnDeath)
	UpdateUI(healthComponent)

func OnTakeDamage(playerHealthComponent):
	UpdateUI(playerHealthComponent)

func OnDeath(playerHealthComponent):
	UpdateUI(playerHealthComponent)

func UpdateUI(healthComponent):
	for child in get_children():
		child.queue_free()

	for x in range(0, healthComponent.Amount):
		var instance = LifeUIElement.instantiate()
		add_child(instance)
