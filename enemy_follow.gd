extends "enemy.gd"

func _ready():
	set_target_pos(player.position)


func _process(delta):
	seeing_player(player.position)
	var move_distance = speed * delta
	move(move_distance)
	

func after_move():
	set_target_pos(player.position)