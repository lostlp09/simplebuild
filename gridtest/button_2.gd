extends Button
@onready var object = self.get_parent().get_parent()

func _pressed() -> void:
	Savescript.savedata[Savescript.currentlevel] = object.placed
	Savescript.Savedandcreatelevel()
	
