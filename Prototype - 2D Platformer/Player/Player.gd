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
var spawned : bool = false

onready var pause = $CanvasLayer/Pause
var world
var level = 1

func _ready() -> void:
	pause.visible = false
	spawn = get_parent().get_node('spawn')
	position = spawn.position
	direction = Vector2.RIGHT
	jumpCount = jumpLimit

func respawn():
	movement = Vector2.ZERO
	direction = Vector2.RIGHT
	jumpCount = jumpLimit
	spawned = true
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
			if tileId == 3:
				win()
			if tileId == 2:
				respawn()

	if not is_on_floor():
		movement.y += gravity
	else:
		if spawned:
			spawned = false
		movement.y = 0
		jumpCount = 0
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			if not spawned:
				movement.x = lerp(movement.x,direction.x * speed,15 * delta)
		else:
			movement.x = lerp(movement.x,0,delta)

	if is_on_ceiling():
		movement.y += gravity

	if raycast.is_colliding():
		if raycast.get_collider() is TileMap:
			var tilemap = raycast.get_collider()
			var point = raycast.get_collision_point() + direction
			var tileId = tilemap.get_cellv(tilemap.world_to_map(point))
			if tileId == 3:
				win()
			if tileId == 2:
				respawn()
			if tileId == 0:
				raycast.set_cast_to(Vector2(-raycast.cast_to.x,0))
				direction.x = -direction.x
				movement.x = -movement.x


	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")) and jumpCount < jumpLimit and not spawned:
		movement.y = -jump
		jumpCount += 1
	move_and_slide(movement,Vector2.UP)



