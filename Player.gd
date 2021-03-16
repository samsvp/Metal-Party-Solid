extends KinematicBody2D

# Declare member variables here. Examples:
const MOVE_SPEED = 150
onready var playerAnim = get_node("PlayerAnim") 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var last_movement = Vector2()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var move_vec = Vector2(0, 0)
	if Input.is_action_pressed("ui_up"):
		move_vec.y -= 1
		if playerAnim.animation != "WalkUp":
			playerAnim.play("WalkUp")
	if Input.is_action_pressed("ui_down"):
		move_vec.y += 1
		if playerAnim.animation != "WalkDown":
			playerAnim.play("WalkDown")
	if Input.is_action_pressed("ui_left"):
		move_vec.x -= 1
		if playerAnim.animation != "WalkLeft" and move_vec.y == 0:
			playerAnim.play("WalkLeft")
	if Input.is_action_pressed("ui_right"):
		move_vec.x += 1
		if playerAnim.animation != "WalkRight" and move_vec.y == 0:
			playerAnim.play("WalkRight")
			
	if move_vec == Vector2(0, 0) and last_movement != Vector2(0, 0):
		if last_movement.x == 1: playerAnim.play("IdleRight")
		elif last_movement.x == -1: playerAnim.play("IdleLeft")
		elif last_movement.y == -1: playerAnim.play("IdleUp")
		elif last_movement.y == 1: playerAnim.play("Idle")
		
	last_movement = move_vec
	move_vec = move_vec.normalized()
	move_and_collide(move_vec * MOVE_SPEED * delta)


func _on_Level_1__body_entered(body):
	pass # Replace with function body.
