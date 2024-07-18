extends StaticBody2D

var bCanModulate = true

var DefaultAlpha = .5

func _ready():
	modulate.a = DefaultAlpha
func _on_area_2d_area_entered(area):
	Modulate()
	if area is Bullet:
		area.queue_free()


func Modulate():
	if bCanModulate:
		bCanModulate = false
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 1, .1)
		await tween.finished
		tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", DefaultAlpha, .1)
		await tween.finished
		bCanModulate = true

func _on_area_2d_body_entered(body):
	Modulate()
