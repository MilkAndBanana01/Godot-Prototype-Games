extends Position2D

export (Array,PackedScene) var pickups
var spawning = false
var dist = 0

func _process(delta: float) -> void:
	if spawning and get_tree().root.get_node('World/Pickups').get_child_count() < 11:
		spawning = false
		var distance = false
		while not distance:
			global_position = randomPos()
			dist = position.distance_to(get_tree().root.get_node('World/Player').global_position)
			if dist > get_tree().root.get_node("World/Player/Safe/CollisionShape2D").shape.radius:
				distance = true
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var pickup
		if rng.randi_range(0,1) == 0:
			pickup = load("res://Pickups/Ammo.tscn").instance()
		else:
			pickup = load("res://Pickups/Health.tscn").instance()
		get_tree().root.get_node('World/Pickups').add_child(pickup)
		pickup.global_position = global_position
		$Timer.wait_time = rng.randi_range(30,60)
		$Timer.start()

func pause():
	$Timer.paused = true
func cont():
	$Timer.paused = false

func randomPos() -> Vector2:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var x = rng.randf_range(400, -400)
	var y = rng.randf_range(200, -200)
	return Vector2(x,y)

func _on_Timer_timeout() -> void:
	spawning = true
