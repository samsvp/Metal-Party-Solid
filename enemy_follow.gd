extends "animated_enemy.gd"

export var min_distance = 50.0
	
func _ready():
	set_target_pos(player.position)

func _process(delta):
	var move_distance = speed * delta
	
	if seeing_player():
		set_target_pos(player.position)
	
	if self.position.distance_to(player.position) > min_distance:
		move(move_distance)
