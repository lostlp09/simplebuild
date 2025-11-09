extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Savescript.loadlevel()
	var anzahl = 0
	for i in Savescript.savedata:
		
		var clone = Button.new()
		clone.size = Vector2(57.0,38.0)
		clone.pressed.connect(buttonpressed.bind(anzahl))
		clone.position = Vector2(1095.0,602.0 - (50 * anzahl))
		clone.text = "level" + str(anzahl +1)
		self.add_child(clone)
		anzahl += 1

func buttonpressed(index)->void:
	Savescript.currentlevel = index
	get_tree().change_scene_to_file("res://node_2d.tscn")
	
	
