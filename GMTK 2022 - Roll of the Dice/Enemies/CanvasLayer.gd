extends CanvasLayer

var paused

func _ready() -> void:
	offset.x = ProjectSettings.get_setting("display/window/size/width")/2
	offset.y = ProjectSettings.get_setting("display/window/size/height")/2

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") and owner.get_node("Player").playing:
		paused = true
		owner.get_node("Player").paused = paused
		get_tree().paused = paused
		$Menu/Settings.visible = false
		$Menu/Pause.visible = paused
		$Menu.visible = paused

func _on_resume_pressed() -> void:
		paused = false
		owner.get_node("Player").paused = paused
		get_tree().paused = paused
		$Menu/Pause.visible = paused
		$Menu.visible = paused
