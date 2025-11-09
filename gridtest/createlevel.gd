extends Button

func _pressed() -> void:
	Savescript.savedata.append([])
	
	if Savescript.savedata.size() > 0:
		Savescript.currentlevel = Savescript.savedata.size() -1
	else:
		Savescript.currentlevel = 0
	get_tree().change_scene_to_file("res://node_2d.tscn")
