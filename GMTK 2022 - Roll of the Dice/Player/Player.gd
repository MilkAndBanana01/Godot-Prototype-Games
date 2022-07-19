#- Add credits

extends KinematicBody2D

var gunSound = load("res://Player/SFX/gun.ogg")
var shotgunSound = load("res://Player/SFX/shotgun.mp3")

var paused = false
var playing = false
var dead = false
var damaged = false

export var speed := 10
export (PackedScene) var bullet
var cards = load("res://Cards/Cards.tscn")
var movement : Vector2

var health = 10
var healthLimit = 10
var bulletCount = 300
var bulletLimit = 300
var score = 0
var multiplier = 1

var revive = false
var reload = false
var inv = false
var knockback : Vector2

func shoot():
	if bulletCount >= 1 and playing:
		bulletCount -= 1
		var b = bullet.instance()
		if b.name == 'shotgun':
			$AudioStreamPlayer.set_stream(shotgunSound)
			$Timer.wait_time = 1
			knockback($Middle/BulletSpawnPos.global_position,500)
			for i in b.get_children():
				var rng = RandomNumberGenerator.new()
				rng.randomize()
				i.speed = rng.randi_range(750,1000)
		else:
			$AudioStreamPlayer.set_stream(gunSound)
			$Timer.wait_time = 0.1
		owner.get_node('Bullets').add_child(b)
		$Timer.start()
		$AudioStreamPlayer.play()
		b.transform = $Middle/BulletSpawnPos.global_transform

func _process(delta: float) -> void:
	if playing:
		health  = clamp(health,0,healthLimit)
		bulletCount  = clamp(bulletCount,0,bulletLimit)
		if Input.is_action_pressed('click') and not reload:
			shoot()
			reload = true
		owner.get_node('CanvasLayer/Game/Health').text = str(health)
		owner.get_node('CanvasLayer/Game/Bullet').text = str(bulletCount)
		owner.get_node('CanvasLayer/Game/Score').text = str(score)
		owner.get_node('CanvasLayer/Game/Multiplier').text = "X" + str(multiplier)
		owner.get_node('CanvasLayer/Game/Revive').visible = revive
		owner.get_node('CanvasLayer/Game/Waves').text = "Wave " + str(owner.get_node('Spawner').wave)
		$Middle.look_at(get_global_mouse_position())

		var mouseAngle = rad2deg(get_angle_to(get_global_mouse_position()))
		if mouseAngle < 90 and mouseAngle > -90:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
		if mouseAngle < 0:
			$Sprite.animation = 'back'
			if (mouseAngle > -180 and mouseAngle < -145) or (mouseAngle > -45 and mouseAngle < 0):
				$Sprite.animation = '45back'
		else:
			$Sprite.animation = 'front'
			if (mouseAngle < 180 and mouseAngle > 145) or (mouseAngle < 45 and mouseAngle > 0):
				$Sprite.animation = '45'

		if not damaged:
			var input = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
			movement = movement.linear_interpolate(input * speed, delta * 15)
		else:
			movement = Vector2.ZERO
		move_and_slide(knockback + movement)
		knockback = lerp(knockback, Vector2.ZERO, 0.1)

func knockback(damagePos,mult):
	damaged()
	var knockbackDir = (global_position - damagePos).normalized()
	knockback = knockbackDir * mult
	inv = true
	yield(get_tree().create_timer(.5), "timeout")
	inv = false

func damaged():
	damaged = true
	owner.get_node('SFX').hit()
	yield(get_tree().create_timer(.1), "timeout")
	damaged = false

func dead():
	if not revive:
		owner.get_node('CanvasLayer/Game').visible = false
		dead = true
		for i in owner.get_node('Bullets').get_children():
			i.queue_free()
		playing = false
		owner.get_node('CanvasLayer/Menu').visible = true
		owner.get_node("CanvasLayer/Menu/Dead").visible = true
		owner.get_node('Save').saveGame(score)
	else:
		health = healthLimit
		revive = false
		for i in owner.get_node('Bullets').get_children():
			i.queue_free()
		for i in owner.get_node('Enemies').get_children():
			i.queue_free()

func _on_Play_pressed() -> void:
	playing = true
	dead = false
	score = 0
	health = 10
	healthLimit = 10
	bulletCount = 300
	bulletLimit = 300
	for i in owner.get_node('Bullets').get_children():
		i.queue_free()
	for i in owner.get_node('Enemies').get_children():
		i.queue_free()
	for i in owner.get_node('Pickups').get_children():
		i.queue_free()
	owner.get_node('Spawner').restart()
	owner.get_node('Spawner').spawning = true
	owner.add_child(cards.instance())
	owner.get_node("CanvasLayer/Menu/Dead/VBoxContainer/new highscore").visible = false
	owner.get_node('Pickup Spawner').spawning = true
	owner.get_node('CanvasLayer/Menu').visible = false
	owner.get_node('CanvasLayer/Menu/Main').visible = false
	owner.get_node('CanvasLayer/Menu/Dead').visible = false
	owner.get_node('CanvasLayer/Game').visible = true

func _on_Settings_pressed() -> void:
	owner.get_node('CanvasLayer/Menu/Main').visible = false
	owner.get_node('CanvasLayer/Menu/Dead').visible = false
	owner.get_node('CanvasLayer/Menu/Settings').visible = true
	owner.get_node('CanvasLayer/Menu/Pause').visible = false

func _on_Back_pressed() -> void:
	owner.get_node('CanvasLayer/Menu/Credits').visible = false
	owner.get_node('CanvasLayer/Menu/Settings').visible = false
	if playing == false:
		if not dead:
			owner.get_node('CanvasLayer/Menu/Main').visible = true
		else:
			owner.get_node('CanvasLayer/Menu/Dead').visible = true
	else:
		owner.get_node('CanvasLayer/Menu/Pause').visible = true

func _on_Timer_timeout() -> void:
	reload = false


func _on_AudioStreamPlayer_finished() -> void:
	$AudioStreamPlayer.stop()

func _on_Credits_pressed() -> void:
	owner.get_node('CanvasLayer/Menu/Main').visible = false
	owner.get_node('CanvasLayer/Menu/Dead').visible = false
	owner.get_node('CanvasLayer/Menu/Credits').visible = true
