extends KinematicBody2D

onready var enemyAnim = get_node("../EnemyAnim")
# Declare member variables here. Examples:
var heading = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func update():
	heading = get_node("..").get("heading")
	if abs(heading[0])>abs(heading[1]):
		if heading[0] > 0:
			if enemyAnim.animation != "WalkRight":
				enemyAnim.play("WalkRight")
		else:
			if enemyAnim.animation != "WalkLeft":
				enemyAnim.play("WalkLeft")
	else:
		if heading[1] < 0:
			if enemyAnim.animation != "WalkUp":
				enemyAnim.play("WalkUp")
		else:
			if enemyAnim.animation != "WalkDown":
				enemyAnim.play("WalkDown")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass