extends Node2D
@onready var gridobject = $Icon
@onready var camera = $Camera2D
var zoom = 0
var camerapos
var placed = []
@onready var bild =$Sprite2D
func _ready() -> void:
	camerapos = camera.position
	zoom = camera.zoom
	grid()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	var position1 =  get_global_mouse_position()

	position1 = clearpos(position1)
	bild.position = position1


	
	pass

func clearpos(posi) ->Vector2:
	return round(posi / 64) *64 
	
func grid():
	for i in range(0,64):
		var clone = gridobject.duplicate()
		var cloney = gridobject.duplicate()
		cloney.rotation_degrees = 90
		cloney.position.y = -352 +i * 64
		cloney.position.x = 300
		clone.position.y = 0
		clone.position.x = -672 +i * 64
		self.add_child(clone)
		self.add_child(cloney)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("place"):
		var clone = bild.duplicate()
		clone.position = bild.position
		self.add_child(clone)
		
	if event is InputEventMouseMotion and Input.is_action_pressed("rightclick"):
		camerapos.x += event.relative.x * -1
		print(camerapos.x)
		camerapos.y += event.relative.y * -1
		camerapos.y = clamp(camerapos.y,-32,736)
		camerapos.x = clamp(camerapos.x,-32,1246)
		camera.position = Vector2(camerapos.x,camerapos.y)
