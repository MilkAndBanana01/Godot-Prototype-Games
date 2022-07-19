extends Node

var score_file = "user://score.save"

var highscore = 0

func _ready() -> void:
	var file = File.new()
	if file.file_exists(score_file):
		file.open(score_file, File.READ)
		highscore = file.get_var()
		file.close()
	else:
		file.open(score_file, File.WRITE)
		file.store_var(highscore, true)
		file.close()

func saveGame(score):
	if score > highscore:
		highscore = score
		owner.get_node("CanvasLayer/Menu/Dead/VBoxContainer/new highscore").visible = true
		var file = File.new()
		file.open(score_file, File.WRITE)
		file.store_var(highscore, true)
		file.close()

func _on_Clear_pressed() -> void:
		var file = File.new()
		file.open(score_file, File.WRITE)
		highscore = 0
		file.store_var(highscore, true)
		file.close()
