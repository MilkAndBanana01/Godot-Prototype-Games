extends Label

func _process(delta: float) -> void:
	text = comma_sep(get_tree().root.get_node('World/Player').score)

func comma_sep(number):
	var string = str(number)
	var mod = string.length() % 3
	var res = ""

	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ","
		res += string[i]

	return res
