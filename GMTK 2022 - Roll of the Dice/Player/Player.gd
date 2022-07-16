#- Implement highscore feature
#- Make the three card scene
#- Allow you to use the three cards after 5 waves
#- Implement Music and settings
#- Add credits

extends KinematicBody2D

var paused = false
var playing = false

export var speed := 10
export (PackedScene) var bullet
var movement : Vector2

var health = 10
var bulletCount = 300
var score = 0

var reload = false
var inv = false

func shoot():
	if bulletCount >= 1 and playing:
		$Timer.start()
		bulletCount -= 1
		var b = bullet.instance()
		owner.get_node('Bullets').add_child(b)
		b.transform = $Middle/BulletSpawnPos.global_transform

func _process(delta: float) -> void:
	if playing:
		if Input.is_action_pressed('click') and not reload:
			shoot()
			reload = true
		owner.get_node('Game/Health').text = str(health)
		owner.get_node('Game/Bullet').text = str(bulletCount)
		owner.get_node('Game/Score').text = str(score)
		owner.get_node('Game/Waves').text = "Wave " + str(owner.get_node('Spawner').wave)
		$Middle.look_at(get_global_mouse_position())
		var input = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
		movement = movement.linear_interpolate(input * speed, delta * 15)
		move_and_slide(movement)

func knockback():
	move_and_slide(-movement * 10)
	inv = true
	yield(get_tree().create_timer(.5), "timeout")
	inv = false

func dead():
	for i in owner.get_node('Bullets').get_children():
		i.queue_free()
	playing = false
	owner.get_node('Menu').visible = true
	owner.get_node("Menu/Dead").visible = true

func _on_Play_pressed() -> void:
	playing = true
	owner.get_node('Spawner').restart()
	score = 0
	health = 10
	bulletCount = 300
	owner.get_node('Spawner').wave(true)
	owner.get_node('Menu').visible = false
	owner.get_node('Menu/Main').visible = false
	owner.get_node('Game').visible = true

func _on_Settings_pressed() -> void:
	owner.get_node('Menu/Main').visible = false
	owner.get_node('Menu/Dead').visible = false
	owner.get_node('Menu/Settings').visible = true
	owner.get_node('Menu/Pause').visible = false

func _on_Back_pressed() -> void:
	owner.get_node('Menu/Settings').visible = false
	if paused == false:
		owner.get_node('Menu/Main').visible = true
	else:
		owner.get_node('Menu/Pause').visible = true

func _on_Timer_timeout() -> void:
	reload = false
