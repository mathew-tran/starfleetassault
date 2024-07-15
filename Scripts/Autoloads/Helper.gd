extends Node


func DegreesToUnitCircle(degrees: float) -> Vector2:
	var radians = deg_to_rad(degrees)
	var x = cos(radians)
	var y = sin(radians)
	return Vector2(x, y)
