extends Node2D
@onready var gridobject = $Icon
@onready var camera = $Camera2D
@onready var staticbody = $StaticBody2D
var pressed = false
var zoom = 0
var groups = "grassblock"
var camerapos
@export var  placed = []
var character = preload("res://images/character_body_2d.tscn")
var oldpos = 0
var slot1 = preload("res://GRAS.png")
var slot2 = preload("res://dirt.png")
var slot3 = preload("res://images/spike.png")
var playerslot =  preload("res://images/player.png")
var slot5 = preload("res://images/flag.png")
var playerspawner = false
var playertexture = null
@onready var area = $Area2D 
@onready var bild =$Sprite2D
var not_at_playbutton = true
func _ready() -> void:
	for i in camera.get_children():
		if i is Button:
			i.mouse_entered.connect(mouseenter)
			i.mouse_exited.connect(mouseexit)
	loadcurrenlevel()
	camerapos = camera.position
	zoom = camera.zoom
	grid()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(playerspawner)
	var cursorpos = get_viewport().get_mouse_position()
	

	if pressed == false  and cursorpos.y <= 426	and not_at_playbutton  :

		bild.visible = true
		var position1 =  get_global_mouse_position()
		position1 = clearpos(position1)
		bild.position = position1
		
	else:
		bild.visible = false
		
func clearpos(posi) ->Vector2:
	return round(posi / 64) *64 
	
func grid():
	for i in range(0,64):
		var clone = gridobject.duplicate()
		var cloneY = gridobject.duplicate()
		cloneY.rotation_degrees = 90
		cloneY.position.y = -352 +i * 64
		cloneY.position.x = 300
		clone.position.y = 0
		clone.position.x = -672 +i * 64
		self.add_child(clone)
		self.add_child(cloneY)
	
func _input(event: InputEvent) -> void:
	var cursorpos = get_viewport().get_mouse_position()
	
	if Input.is_action_just_pressed("slot1"):
		groups = "grassblock"
		bild.texture = slot1
	if Input.is_action_just_pressed("slot2"):
		groups = "dirtblock"
		bild.texture = slot2
	if Input.is_action_just_pressed("slot3"):
		groups = "killblock"
		bild.texture = slot3
	if Input.is_action_just_pressed("slot4"):
		groups = "player"
		bild.texture = playerslot
	if Input.is_action_just_pressed("slot5"):
		groups = "goal"
		bild.texture = slot5
	if Input.is_action_pressed("delete"): 

		var pos = round(get_global_mouse_position()/64) * 64
		if pos != oldpos and placed.size() >0:
			
			for i in placed:
				
	
				if i["block"].position == pos:
					if i["groups"] == "player":
						playerspawner = false
				
					i["block"].queue_free()
					placed.erase(i)
					break
				
			oldpos = pos
	
				
	if Input.is_action_pressed("place") and pressed == false and cursorpos.y <= 426	and not_at_playbutton  :
		oldpos = null
		var pos = bild.position
		if placed.size() > 0:
		
			if placed[placed.size()-1]["block"].position != pos and (playerspawner
			 == false or groups != "player"):
				for i in placed:
					if i["block"].position == pos:
						placed.erase(i)
						i["block"].queue_free()
						break
		
				var clone = bild.duplicate()
				clone.position = pos
				self.get_node("clone").add_child(clone)
				placed.append({"block":clone,"groups":groups,"position":clone.position})
				if groups == "player":
					playerspawner = true
			else:
				if placed[placed.size()-1]["groups"] != groups and (playerspawner == false or groups != "player"):
					print("kill")
					var clone = bild.duplicate()
					clone.position = pos
					self.get_node("clone").add_child(clone)
					placed[placed.size()-1]["block"].queue_free()
					placed.erase(placed[placed.size()-1])
					placed.append({"block":clone,"groups":groups,"position":clone.position})
					if groups == "player":
						playerspawner = true	
		else:
			var clone = bild.duplicate()
			clone.position = pos
			self.get_node("clone").add_child(clone)
			
			placed.append({"block":clone,"groups":groups,"position":clone.position})
			if groups == "player":
				playerspawner = true
	if event is InputEventMouseMotion and Input.is_action_pressed("rightclick") and pressed == false:

		camerapos.x += event.relative.x * -1
	
		print(camerapos.x)
		camerapos.y += event.relative.y * -1
		camerapos.y = clamp(camerapos.y,-32,736)
		camerapos.x = clamp(camerapos.x,-32,1246)
		camera.position = Vector2(camerapos.x,camerapos.y)




func _on_button_pressed() -> void:
	var button = $Camera2D/Button
	if pressed == false and playerspawner == true:
		camera.get_node("TextureRect").visible = false
		pressed = true
		button.text = "reset"
		print("hi")
		
		for i in placed:
			
			if i["groups"] == "dirtblock" or i["groups"] == "grassblock":
				var collision = CollisionShape2D.new()
				var shape = RectangleShape2D.new()
				collision.shape= shape
				collision.scale = Vector2(1,1) * 3.2
			
				print(shape.size)
				collision.position = i["block"].position
				staticbody.add_child(collision)
			
			elif i["groups"] == "player":
				
				var clone = character.instantiate()
				clone.position = i["block"].position
				i["block"].visible = false
				playertexture = i["block"]
				self.get_node("clone").add_child(clone)
				camera.position = clone.position
				camera.reparent(clone)
			
			elif i["groups"] == "killblock":
				var collision = CollisionShape2D.new()
				var shape = RectangleShape2D.new()
				collision.shape=  shape
				collision.scale = Vector2(1,1) 
				collision.position = i["block"].position
				area.add_child(collision)
			elif i["groups"] == "goal":
				var collision = CollisionShape2D.new()
				var shape = RectangleShape2D.new()
				collision.shape=  shape
				collision.scale = Vector2(1,1) 
				collision.position = i["block"].position
				area.add_child(collision)
	else:
		camera.get_node("TextureRect").visible = true
		camera.get_node("Button").text = "Play"
		pressed = false
		camera.reparent(self)
		for bodys in staticbody.get_children():
			bodys.queue_free()
		for i in self.get_node("clone").get_children():
			if i is CharacterBody2D:
				print("dead")
				i.queue_free()
				playertexture.visible = true
				break
		for areas in area.get_children(1):
			areas.queue_free()
			
func _on_area_2d_body_entered(body: Node2D) -> void:
		for index in placed:
			if index["groups"] == "player":
				body.position = index["block"].position





func _on_grass_pressed() -> void:
	groups = "grassblock"
	bild.texture = slot1


func _on_dirt_pressed() -> void:
	groups = "dirtblock"
	bild.texture = slot2



func _on_spike_pressed() -> void:
	groups = "killblock"
	bild.texture = slot3


func _on_player_pressed() -> void:
	bild.texture = playerslot
	groups = "player"


func mouseexit() -> void:
	not_at_playbutton = true
func mouseenter() -> void:
	not_at_playbutton = false
func loadcurrenlevel()->void:
	var currentlevel = Savescript.currentlevel
	for i in Savescript.savedata[currentlevel]:
		var clone = Sprite2D.new()
		clone.position = i["position"] 
		clone.add_to_group(i["groups"])
		if i["groups"] == "grassblock":
			clone.texture = slot1
		elif i["groups"] == "dirtblock":
			clone.texture = slot2
		elif i["groups"] == "killblock":
			clone.texture = slot3
		elif i["groups"] == "player":
			playerspawner = true
			clone.texture = playerslot
		elif i["groups"] == "goal":
			clone.texture = slot5
		
		self.get_node("clone").add_child(clone)
		placed.append({"block":clone,"groups":i["groups"],"position":i["position"]})

func _on_goal_pressed() -> void:
	bild.texture = slot5
	groups = "goal"
