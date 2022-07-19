extends CPUParticles2D

func _ready() -> void:
	$Timer.wait_time = lifetime + 0.1
	emitting = true

func _on_Timer_timeout() -> void:
	queue_free()
