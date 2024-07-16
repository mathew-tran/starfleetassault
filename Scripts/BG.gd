extends TextureRect

var TimePassed = 0.0

func _process(delta):
	TimePassed += delta
	material.set_shader_parameter("time", TimePassed)
