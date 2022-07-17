extends Node2D

func _ready():
	for i in get_children():
		if i is Button:
			i.connect('pressed',$SFX,'buttonPress')
