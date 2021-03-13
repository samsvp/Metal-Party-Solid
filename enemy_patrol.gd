extends KinematicBody2D

export var speed = 100.0
var path = PoolVector2Array()

# detection properties
export var view_distance = 200
export var fov = 90 # detection fov
onready var cfov = cos(deg2rad(fov))

onready var path_2d = get_node("../Waypoints")
onready var nav_2d = get_node("../Navigation2D")
onready var line_2d = get_node("../Line2D")
onready var player = get_node("../Player")
onready var ray = get_node("RayCast2D")

onready var curve = path_2d.get_curve()
onready var heading = Vector2(-1 ,0)


######### better print #########
var c=1
func debug(message):
	print(c, ": ", message)
	c+=1


func set_target_pos(pos):
	var new_path = nav_2d.get_simple_path(self.global_position, pos)
	path = new_path


func _ready():
	randomize()
	var target = curve.get_point_position(randi() % curve.get_point_count())
	set_target_pos(target)


func seeing_player(player_pos):
	ray.cast_to =  player_pos - self.position
	if ray.is_colliding():
		if not ray.get_collider().is_in_group("Player"):
			return false
	if  view_distance < self.position.distance_to(player_pos):
		return false
	var enemy_to_player = (player_pos - self.position).normalized()
	if enemy_to_player.dot(heading) > cfov:
		line_2d.default_color = Color.red # debug
		return true
	return false


func _process(delta):
	# debug
	line_2d.default_color = Color.blue
	var los = PoolVector2Array()
	los.push_back(self.global_position)
	los.push_back(self.global_position + heading*200)
	line_2d.points = los
	#
	
	var move_distance = speed * delta
	patrol(move_distance)
	seeing_player(player.position)


func patrol(distance):
	var start_point = position
	for i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			heading = (path[0] - position).normalized()
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
