extends Area2D

var enemyBullet = false
export var speed = 750

func _process(delta: float) -> void:
	if enemyBullet:
		$Sprites/Enemy.visible = true
	else:
		$Sprites/Enemy.visible = false
	position += transform.x * speed * delta
	if $RayCast2D.is_colliding():
		var collide = $RayCast2D.get_collider()
		if collide is TileMap:
			queue_free()
		if not enemyBullet:
			if (collide is KinematicBody2D and collide.is_in_group('enemy')):
				get_tree().root.get_node('World/Player').score += collide.enemy * collide.currentWave * 10 * get_tree().root.get_node('World/Player').multiplier
				collide.health -= 1
				collide.hit()
				queue_free()
			elif (collide is Area2D and collide.is_in_group('enemy')):
				get_tree().root.get_node('World/Player').score += collide.get_parent().enemy * collide.get_parent().currentWave * 10 * get_tree().root.get_node('World/Player').multiplier
				collide.get_parent().health -= 1
				collide.get_parent().hit()
				queue_free()
		else:
			if (collide is KinematicBody2D and collide.is_in_group('player')):
				if collide.inv == false:
					collide.health -= 1
				collide.knockback(global_position,300)
				if collide.health <= 0:
					collide.dead()
				queue_free()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
