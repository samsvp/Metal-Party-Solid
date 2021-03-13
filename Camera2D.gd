extends Camera2D

onready var player = get_node("../Player")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	position.x = player.position.x # Replace with function body.
	position.y = player.position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
