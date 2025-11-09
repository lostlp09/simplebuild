extends Node

@onready var objects = $"../Node2D"
var savedata:Array = []
var currentlevel = 0


func Savedandcreatelevel()->void:
	var content = savedata
	var file = FileAccess.open("user://gridbuildsave.txt",FileAccess.WRITE)
	file.store_var(content)
	file.close()
func loadlevel()->void:
	
	var file =FileAccess.open("user://gridbuildsave.txt",FileAccess.READ)
	if file:
		var content = file.get_var()
		file.close
		savedata = content
	
						
					

		
	if file != null:
		pass	
	else:
		savedata = []

	

  
