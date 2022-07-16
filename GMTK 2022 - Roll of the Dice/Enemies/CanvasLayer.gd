extends CanvasLayer

var paused

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") and owner.get_node("Player").playing:
		paused = true
		owner.get_node("Player").paused = paused
		get_tree().paused = paused
		owner.get_node("Menu/Pause").visible = paused
		owner.get_node('Menu').visible = paused

func _on_resume_pressed() -> void:
		paused = false
		owner.get_node("Player").paused = paused
		get_tree().paused = paused
		owner.get_node("Menu/Pause").visible = paused
		owner.get_node('Menu').visible = paused
