extends Area2D

var speed = 750

func _process(delta: float) -> void:
	position += transform.x * speed * delta
	if $RayCast2D.is_colliding():
		var collide = $RayCast2D.get_collider()
		if collide is TileMap:
			queue_free()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
