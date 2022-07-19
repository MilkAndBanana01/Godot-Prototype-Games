extends AudioStreamPlayer

export (Array,AudioStream) var sfx 
var musicEnable = true
var sfxEnable = true

func _process(delta: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Music'),owner.get_node("CanvasLayer/Menu/Settings/VBoxContainer/Music/HSlider").value - 10)

func _on_HSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('SFX'),value - 10)
	stream = sfx[0]
	play()

func _on_music_pressed() -> void:
	musicEnable = !musicEnable
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"),!musicEnable)
	owner.get_node("CanvasLayer/Menu/Settings/VBoxContainer/Music/HSlider").editable = musicEnable

func _on_sfx_pressed() -> void:
	sfxEnable = !sfxEnable
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"),!sfxEnable)
	owner.get_node("CanvasLayer/Menu/Settings/VBoxContainer/SFX/HSlider").editable = sfxEnable

func buttonPressed():
	stream = sfx[1]
	play()

func hit():
	stream = sfx[2]
	play()
