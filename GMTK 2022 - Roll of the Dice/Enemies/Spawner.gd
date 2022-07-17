extends Position2D

export (PackedScene) var enemy

var wave = 1
var mobSpawn = 3
var spawning = false

func restart():
	$Timer.start()
	for i in owner.get_node('Enemies').get_children():
		i.queue_free()
	wave = 1
	mobSpawn = 3

func wave(first):
	yield(get_tree().create_timer(1.0), "timeout")
	for i in owner.get_node('Enemies').get_children():
		if i.name == "Placement":
			i.queue_free()
	while mobSpawn > 0:
		spawning = true
		global_position = randomPos()
		var dist = position.distance_to(get_tree().root.get_node('World/Player').global_position)
		if dist > get_tree().root.get_node("World/Player/Safe/CollisionShape2D").shape.radius:
			var spawn = enemy.instance()
			owner.get_node('Enemies').add_child(spawn)
			mobSpawn -= 1
#			owner.get_node('Enemies').call_deferred('add_child',spawn)
			spawn.global_position = global_position
			spawn.spawnMonster(wave)
			yield(get_tree(),'idle_frame')
	if not first:
		wave += 1
	if wave < 21:
		if wave % 5 != 0:
			mobSpawn += 2 + wave/4
		else:
			mobSpawn = 5 + wave/2
	else:
		mobSpawn = wave/2
	spawning = false

func randomPos() -> Vector2:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var x = rng.randf_range(400, -400)
	var y = rng.randf_range(200, -200)
	return Vector2(x,y)

func _process(delta: float) -> void:
	var enemies = owner.get_node('Enemies').get_child_count()
	if enemies == 0 and not spawning:
		if wave % 5 == 0:
			spawning = true
			owner.add_child(load("res://Cards/Cards.tscn").instance())
		else:
			spawning = true
			wave(false)
