extends Position2D

export (PackedScene) var enemy

var wave = 20
var mobSpawn = 3
var enemies
var spawning = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		wave(false)

func restart():
	for i in owner.get_node('Enemies').get_children():
		i.queue_free()
	wave = 20
	mobSpawn = 3

func wave(first):
	for i in owner.get_node('Enemies').get_children():
		if i.name == "Placement":
			i.queue_free()
	while mobSpawn > 0:
		spawning = true
		global_position = randomPos()
		var dist = position.distance_to(get_tree().root.get_node('World/Player').global_position)
		if dist > get_tree().root.get_node("World/Player/Safe/CollisionShape2D").shape.radius:
			mobSpawn -= 1
			var spawn = enemy.instance()
			owner.get_node('Enemies').call_deferred('add_child',spawn)
			spawn.global_position = global_position
			spawn.spawnMonster(wave)
			yield(get_tree(),'idle_frame')
	if not first:
		wave += 1
	if wave % 5 != 0:
		mobSpawn += 2 + int(wave % 5)
	else:
		if wave < 21:
			mobSpawn = 3 + (wave % 5)
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
	enemies = owner.get_node('Enemies').get_child_count()
	if enemies == 0 and not spawning:
		spawning = true
		yield(get_tree().create_timer(1.0), "timeout")
		wave(false)
