extends KinematicBody2D

export var speed := 10
export (PackedScene) var bullet
var movement : Vector2

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('click'):
		shoot()

func shoot():
	var b = bullet.instance()
	owner.add_child(b)
	b.transform = $Middle/BulletSpawnPos.global_transform

func _process(delta: float) -> void:
	$Middle.look_at(get_global_mouse_position())
	var input = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	movement = movement.linear_interpolate(input * speed, delta * 15)
	move_and_slide(movement)
