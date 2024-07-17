extends Node


func DegreesToUnitCircle(degrees: float) -> Vector2:
	var radians = deg_to_rad(degrees)
	var x = cos(radians)
	var y = sin(radians)
	return Vector2(x, y)

func GetPlayerBulletLayer():
	return 4

func GetEnemyBulletLayer():
	return 5

func GetPlayer():
	var result = get_tree().get_nodes_in_group("Player")
	if result:
		return result[0]
	return null
