extends KinematicBody2D

export (Array,PackedScene) var bullet

var enemy = 1
var speed = 20
var health = 3
var shot = false

var rotating = 1
var shootType = 1

var currentWave

var enemyTypes = {
	1:{
		"speed": [20,100],
		"health": 3
	},
	2:{
		"speed": [200,300],
		"health": 1
	},
	3:{
		"speed": [20,70],
		"health": 10
	},
	4:{
		"speed": [20,100],
		"health": 5
	},
	5:{
		"speed": 0,
		"health": 20
	}
}

var direction : Vector2

func spawnMonster(wave):
	currentWave = wave
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if wave >= 5:
		enemy = rng.randi_range(1,2)
	else:
		enemy = 1
	if wave >= 10:
		enemy = rng.randi_range(1,3)
	if wave >= 15:
		enemy = rng.randi_range(1,4)
	if wave >= 20:
		enemy = rng.randi_range(1,5)
	get_node('Sprites/' + str(enemy)).visible = true
	if enemyTypes[enemy]["speed"] is Array:
		speed = rng.randf_range(enemyTypes[enemy]["speed"][0],enemyTypes[enemy]["speed"][1])
	else:
		speed = 0
	health = enemyTypes[enemy]["health"]
	if enemy == 4:
		$Timer.wait_time = rng.randi_range(1,3)
	if enemy == 5:
		$Timer.wait_time = 0.1
		var rotate = rng.randi_range(0,1)
		if rotate == 0:
			rotating = -1
		shootType = rng.randi_range(0,1)

func _process(delta: float) -> void:
	if get_tree().root.get_node("World/Player").playing:
		direction = (get_tree().root.get_node("World/Player").global_position - global_position).normalized()

		if get_node("Sprites/" + str(enemy)) is AnimatedSprite:
			var mouseAngle = rad2deg(get_angle_to(get_tree().root.get_node("World/Player").global_position))
			if mouseAngle < 90 and mouseAngle > -90:
				get_node("Sprites/" + str(enemy)).flip_h = true
			else:
				get_node("Sprites/" + str(enemy)).flip_h = false
			if mouseAngle < 0:
				get_node("Sprites/" + str(enemy)).animation = 'back'
				if (mouseAngle > -180 and mouseAngle < -145) or (mouseAngle > -45 and mouseAngle < 0):
					get_node("Sprites/" + str(enemy)).animation = '45back'
			else:
				get_node("Sprites/" + str(enemy)).animation = 'front'
				if (mouseAngle < 180 and mouseAngle > 145) or (mouseAngle < 45 and mouseAngle > 0):
					get_node("Sprites/" + str(enemy)).animation = '45'

		if enemy != 4:
			move_and_slide(direction * speed)
		else:
			var dist = position.distance_to(get_tree().root.get_node('World/Player').global_position)
			if dist > $Ranger.shape.radius:
				move_and_slide(direction * speed)
			else:
				move_and_slide(-direction * speed)
		if enemy == 4:
			if not shot:
				shot = true
				$Timer.start()
		if enemy == 5:
			if not shot:
				shot = true
				$Timer.start()
				var b = bullet[shootType].instance()
				if shootType == 0:
					b.enemyBullet = true
					b.speed = 200
				else:
					for i in b.get_children():
						i.enemyBullet = true
						i.speed = 200
				get_tree().root.get_node('World/Bullets').add_child(b)
				$Middle.rotation_degrees += 15 * rotating
				b.transform = $Middle.global_transform
		if health <= 0:
			get_tree().root.get_node("World/Player").score += enemy * currentWave * 100 * get_tree().root.get_node("World/Player").multiplier
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var random = rng.randi_range(0,20)
			if random == 1:
				var bullet = load("res://Pickups/Ammo.tscn").instance()
				get_tree().root.get_node('World/Pickups').add_child(bullet)
				bullet.global_position = global_position
			elif random == 2:
				var health = load("res://Pickups/Health.tscn").instance()
				get_tree().root.get_node('World/Pickups').add_child(health)
				health.global_position = global_position
			queue_free()

func _on_Area2D_body_entered(body: Node) -> void:
	if body is KinematicBody2D and body.is_in_group('player') and not body.inv:
		if body.inv == false:
			body.health -= 1
		health -= 1
		if body.health <= 0:
			body.dead()
		body.knockback(global_position,300)

func _on_Timer_timeout() -> void:
	if enemy == 4 and get_tree().root.get_node("World/Player").playing:
		var b = bullet[0].instance()
		b.enemyBullet = true
		get_tree().root.get_node('World').add_child(b)
		$Middle.look_at(get_tree().root.get_node("World/Player").global_position)
		b.transform = $Middle.global_transform
	shot = false
