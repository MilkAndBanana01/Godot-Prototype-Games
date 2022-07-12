extends KinematicBody2D

var gravity = 50
var d : Vector2
var speed : Vector2
var raycast

func _ready() -> void:
	raycast = get_node("RayCast2D")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if raycast.is_colliding():
			speed = Vector2()
			if Input.is_action_just_pressed("ui_down"):
				d = Vector2.DOWN
				rotation_degrees = 0
			if Input.is_action_just_pressed("ui_up"):
				d = Vector2.UP
				rotation_degrees = 180
			if Input.is_action_just_pressed("ui_left"):
				d = Vector2.LEFT
				rotation_degrees = 90
			if Input.is_action_just_pressed("ui_right"):
				d = Vector2.RIGHT
				rotation_degrees = -90
			yield(get_tree().create_timer(1), "timeout")

func _physics_process(delta: float) -> void:
	if not raycast.is_colliding():
		speed += d * gravity
		move_and_slide(speed,Vector2.UP)
