extends Node2D

var card = 1
var cardID
var cardList
var chosenCard

func _ready() -> void:
	$AnimationPlayer.play("show cards")
	get_tree().root.get_node('World/Pickup Spawner').pause()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var cardNum = 0
	cardList = [rng.randi_range(1,4),rng.randi_range(5,8),rng.randi_range(9,12)]
	for i in get_node("MarginContainer/HBoxContainer").get_children():
		i.texture_normal = load("res://Prototype/Cards/a_" + str(cardList[cardNum]) + ".png")
		i.texture_hover = load("res://Prototype/Cards/a_" + str(cardList[cardNum]) + ".png")
		i.texture_pressed = load("res://Prototype/Cards/a_" + str(cardList[cardNum]) + ".png")
		cardNum += 1

func drew() -> void:
	if not $AnimationPlayer.is_playing():
		card = cardList[chosenCard]
		var player = get_tree().root.get_node('World/Player')
		var rng = RandomNumberGenerator.new()
		var value
		rng.randomize()
		if card == 1:
			value = rng.randi_range(1,6)
			player.health += value
		if card == 2:
			value = rng.randi_range(1,4)
			player.bulletCount += (player.bulletLimit / 4) * value
		if card == 3:
			value = rng.randi_range(1,6)
			player.healthLimit += value
		if card == 4:
			value = rng.randi_range(1,4)
			player.bulletLimit += 25 * value
		if card == 5:
			value = rng.randi_range(1,6)
			player.multiplier = value
		if card == 6:
			player.revive = true
		if card == 7:
			player.bullet  = load("res://Bullet/Bullet.tscn")
		if card == 8:
			player.bullet  = load("res://Bullet/2Bullet.tscn")
		if card == 9:
			player.bullet  = load("res://Bullet/3Bullet.tscn")
		if card == 10:
			player.bullet  = load("res://Bullet/4BulletSpread.tscn")
		if card == 11:
			player.bullet  = load("res://Bullet/8BulletSpread.tscn")
		if card == 12:
			player.bullet  = load("res://Bullet/ShotgunSpread.tscn")
		if value != null:
			$AnimationPlayer.play("dice animation check")
			$AnimationPlayer.queue(str(value))
		else:
			$AnimationPlayer.play("hide cards")
func _on_TextureButton_pressed() -> void:
	chosenCard = 0
	drew()
func _on_TextureButton2_pressed() -> void:
	chosenCard = 1
	drew()
func _on_TextureButton3_pressed() -> void:
	chosenCard = 2
	drew()

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == 'hide cards':
		$AnimationPlayer.stop()
		get_tree().root.get_node('World/Pickup Spawner').cont()
		var spawner = get_tree().root.get_node('World/Spawner')
		if spawner.wave == 1:
			spawner.wave(true)
		else:
			spawner.wave(false)
		queue_free()
	if anim_name != 'dice animation check' and anim_name != 'show cards' and not anim_name == 'hide cards':
		$AnimatedSprite.visible = false
		$AnimationPlayer.play("hide cards")
