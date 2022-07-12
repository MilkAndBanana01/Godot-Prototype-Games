extends KinematicBody

var gravity = 10
var d : Vector3
var speed : Vector3
var raycast

func _ready() -> void:
	raycast = get_node("RayCast")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if raycast.is_colliding():
			speed = Vector3()
			if Input.is_action_just_pressed("ui_up"):
				d = Vector3.UP
				rotation_degrees = Vector3(0,0,180)
			if Input.is_action_just_pressed("ui_down"):
				d = Vector3.DOWN
				rotation_degrees = Vector3(0,0,0)
			if Input.is_action_just_pressed("ui_left"):
				d = Vector3.LEFT
				rotation_degrees = Vector3(0,0,-90)
			if Input.is_action_just_pressed("ui_right"):
				d = Vector3.RIGHT
				rotation_degrees = Vector3(0,0,90)

func _physics_process(delta: float) -> void:
	print(raycast.is_colliding())
	if not raycast.is_colliding():
		speed += d * gravity
		move_and_slide(speed)

