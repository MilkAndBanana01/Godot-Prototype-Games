extends KinematicBody2D

var spawn
onready var timer = $Timer
onready var raycast = $RayCast2D
var jumpCount : int = 0
export var gravity := 10
export var speed := 10
export var jump := 20
var jumpLimit := 1
var direction : Vector2
var movement : Vector2
var snap : Vector2
var upDirection : Vector2
var spawned : bool = false
var slippery := false
var slow := false

onready var pause = $CanvasLayer/Pause
var tilemap
onready var shotgunParticles = preload("res://Player/Particles/shotgun particle.tscn")
onready var jumppad = preload("res://Tilemap/Instances/Jump.tscn")
var world
var level = 1

func _ready() -> void:
	upDirection = Vector2.UP
	world = get_parent()
	pause.visible = false
	spawn = get_parent().get_node('spawn')
	position = spawn.position
	direction = Vector2.RIGHT
	jumpCount = jumpLimit
	tilemap = world.get_node("tilemap")
	var tiles = tilemap.get_used_cells_by_id(4)
	for i in tiles:
		var t = jumppad.instance()
		world.call_deferred("add_child",t)
		yield(get_tree(),"idle_frame")
		t.global_position = i * tilemap.cell_size.x
		tilemap.set_cellv(i, -1)
		tilemap.update_dirty_quadrants()

func respawn():
	spawned = true
	direction = Vector2.RIGHT
	jumpCount = jumpLimit
	$Sprite.flip_h = false
	movement = Vector2.ZERO
	spawn = get_parent().get_node("spawn").position
	position = spawn
	raycast.set_cast_to(Vector2(abs(raycast.cast_to.x),0))

func win():
	level = int(get_tree().root.get_child(0).name)
	level += 1
	if ResourceLoader.exists("res://Levels/" + str(level) + ".tscn"):
		get_tree().change_scene("res://Levels/" + str(level) + ".tscn")
	respawn()

func _physics_process(delta: float) -> void:
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider is TileMap:
			var tilePos = collision.collider.world_to_map(position)
			tilePos -= collision.normal
			var tileId = collision.collider.get_cellv(tilePos)
			if tileId == 0:
				slippery = false
				slow = false
			if tileId == 2:
				respawn()
			if tileId == 3:
				win()
			if tileId == 5:
				slippery = true
			if tileId == 6:
				slow = true
			if tileId == 7:
#				$CollisionShape2D2/Sprite.rotate(deg2rad(180))
				movement.y = -jump
				gravity = -gravity
				jump = -jump
				upDirection = -upDirection

	if not is_on_floor():
		movement.y += gravity
	else:
		snap = -get_floor_normal()
		if spawned:
			spawned = false
		else:
			jumpCount = 0
# if jump pad breaks, remove this line
		movement.y = 0
		if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")) and not slow:
			if not spawned:
				movement.x = lerp(movement.x,direction.x * speed,10 * delta)
		else:
			movement.x = lerp(movement.x,0,delta * (5 * int(not slippery)))

	if is_on_ceiling():
		movement.y += gravity

	if raycast.is_colliding() and not spawned:
		if raycast.get_collider() is TileMap:
			var tilemap = raycast.get_collider()
			var point = raycast.get_collision_point() + direction
			var tileId = tilemap.get_cellv(tilemap.world_to_map(point))
			if tileId == 3:
				win()
			if tileId == 2:
				respawn()
			if tileId == 0:
				$Sprite.flip_h = !$Sprite.flip_h
				$AnimationPlayer.play("side")
				raycast.set_cast_to(Vector2(-raycast.cast_to.x,0))
				direction.x = -direction.x
				movement.x = -movement.x

	if (Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_up")) and jumpCount < jumpLimit and not spawned:
		var shotty = shotgunParticles.instance()
		owner.add_child(shotty)
		shotty.global_position = global_position
		$AnimationPlayer.play("jump")
		snap = Vector2.ZERO
		movement.y = -jump
		jumpCount += 1
		if slow == true:
			movement.x = direction.x * speed
	move_and_slide_with_snap(movement,snap,upDirection)

func jumpPad():
	snap = Vector2.ZERO
	movement.y = -jump
