extends Area2D

func _on_Ammo_body_entered(body: Node) -> void:
	if body.is_in_group('player'):
		if is_in_group('ammo'):
			get_tree().root.get_node('World/Player').bulletCount += 100
			queue_free()
		if is_in_group('health'):
			get_tree().root.get_node('World/Player').health += 1
			queue_free()
