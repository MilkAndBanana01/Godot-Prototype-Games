extends KinematicBody2D

var raycast
var direction : Vector2

func _ready():
	raycast = get_node("RayCast2D")
	direction = Vector2.RIGHT
	raycast.cast_to = direction * 9999

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_left"):
			direction = Vector2.LEFT
		if Input.is_action_just_pressed("ui_right"):
			direction = Vector2.RIGHT
		if Input.is_action_just_pressed("ui_up"):
			direction = Vector2.UP
		if Input.is_action_just_pressed("ui_down"):
			direction = Vector2.DOWN
		move()

func move():
	raycast.cast_to = direction * 9999
	var point = raycast.get_collision_point()
	position = point


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
