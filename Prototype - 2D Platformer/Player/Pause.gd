extends CanvasLayer

onready var pause = get_node("Pause")

func _ready() -> void:
	var pause = $Pause/MarginContainer/VBoxContainer/HBoxContainer3/HBoxContainer2/resume
	pause.connect("pressed",self,"pause")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		pause()

func pause():
	pause.visible = !pause.visible
	get_tree().paused = pause.visible
