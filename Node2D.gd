extends Node

onready var nav_2d : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $Line2D
onready var character : Sprite = $Sprite



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _unhandled_input(event: InputEvent):
	
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	
	var new_path = nav_2d.get_simple_path(character.global_position, get_viewport().get_mouse_position())
	line_2d.points = new_path
	character.path = new_path
	print(new_path)
