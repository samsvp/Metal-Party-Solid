extends "enemy.gd"

# Declare member variables here. Examples:
var enemyAnim = "text"
func _ready():
	var sprites = load(animations[randi()%animations.size()])
	enemyAnim = get_node("./AnimatedSprite")
	enemyAnim.frames = sprites

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
