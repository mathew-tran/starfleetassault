extends CPUParticles2D

class_name ExplodeParticle

func _ready():
	emitting = true

func _on_finished():
	queue_free()
