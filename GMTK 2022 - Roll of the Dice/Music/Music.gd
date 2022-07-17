extends AudioStreamPlayer

func _process(delta: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Music'),owner.get_node("CanvasLayer/Menu/Settings/VBoxContainer/Music/HSlider").value - 10)

func _on_HSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('SFX'),value - 10)
	stream = load("res://UI/button_press.mp3")
	play()

func _on_music_pressed() -> void:
	if AudioServer.get_bus_volume_db(AudioServer.get_bus_index('Music'),owner.get_node("CanvasLayer/Menu/Settings/VBoxContainer/Music/HSlider").value - 10):
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Music'),owner.get_node("CanvasLayer/Menu/Settings/VBoxContainer/Music/HSlider").value - 10)

func _on_sfx_pressed() -> void:
	pass # Replace with function body.



