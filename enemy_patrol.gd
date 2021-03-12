extends Sprite

var speed = 400.0
var path = PoolVector2Array() setget set_path

onready var path_2d = get_node("../Waypoints")
onready var nav_2d = get_node("../Navigation2D")
onready var line_2d = get_node("../Line2D")

onready var curve = path_2d.get_curve()

func set_path(value):
	path = value
	if value.size() == 0:
		return
	#set_process(true)
	
func set_target_pos(pos):
	var new_path = nav_2d.get_simple_path(self.global_position, pos)
	line_2d.points = new_path
	path = new_path

func _ready():
	randomize()
	var target = curve.get_point_position(randi() % curve.get_point_count())
	set_target_pos(target)
	
	pass
	#set_process(false)
	
func _process(delta):
	var move_distance = speed * delta
	patrol(move_distance)
	
func patrol(distance):
	var start_point = position
	for i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance/distance_to_next)
			break
		elif path.size() == 1 && distance > distance_to_next:
			position = path[0]
			# end of the path
			
			# go to new random point 
			var target = curve.get_point_position(randi() % curve.get_point_count())
			set_target_pos(target)
			
			break
			
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)
