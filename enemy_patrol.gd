extends "enemy.gd"


export (NodePath) var waypoints_path
onready var path_2d = get_node(waypoints_path)
onready var curve = path_2d.get_curve()


func _ready():
	randomize()
	var target = curve.get_point_position(randi() % curve.get_point_count())
	set_target_pos(target)

func _process(delta):
	seeing_player(player.position)
	var move_distance = speed * delta
	move(move_distance)

func after_move():
	var target = curve.get_point_position(randi() % curve.get_point_count())
	set_target_pos(target)
