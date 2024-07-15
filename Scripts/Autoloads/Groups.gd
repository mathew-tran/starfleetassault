extends Node


func GetBullets():
	var result = get_tree().get_nodes_in_group("Bullets")
	if result:
		return result[0]
	return null
