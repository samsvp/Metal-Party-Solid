extends Area2D
signal disable_enemies_1(value)
export var destination = Vector2(0,0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _on_Level_1__body_entered(body):
	if body.is_in_group("Player"):
		body.position = destination
		emit_signal("disable_enemies_1",true)
