extends KinematicBody2D

export var speed = 100.0
var path = PoolVector2Array()

# detection properties
export var view_distance = 200
export var fov = 90 # detection fov
onready var cfov = cos(deg2rad(fov))

# get main scene nodes
export (NodePath) var nav_2d_path
onready var nav_2d = get_node(nav_2d_path)
export (NodePath) var player_path
export onready var player = get_node(player_path)

# get enemy nodes
onready var enemyAnim = get_node("EnemyAnim")
onready var ray = get_node("RayCast2D")

onready var heading = Vector2(0, 0)


######################################
########## Enemy base class ##########
# dont attach this class to nodes
# this class should be extended 
# for the different types of enemys
######################################

func _ready():
	pass


func _process(delta):
	pass


func set_target_pos(pos):
	var new_path = nav_2d.get_simple_path(self.global_position, pos)
	path = new_path


func seeing_player(player_pos):
	ray.cast_to =  player_pos - self.position
	if ray.is_colliding():
		if not ray.get_collider().is_in_group("Player"):
			return false
	if  view_distance < self.position.distance_to(player_pos):
		return false
	var enemy_to_player = (player_pos - self.position).normalized()
	if enemy_to_player.dot(heading) > cfov:
		return true
	return false


func before_move():
	pass
	
func after_move():
	pass

func move(distance):
	before_move()
	var start_point = position
	for i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			heading = (path[0] - position).normalized()
			for el in self.get_children():
				el.update()
			position = start_point.linear_interpolate(path[0], distance/distance_to_next)
			break
		elif path.size() == 1 && distance > distance_to_next: # end of the path
			position = path[0]
			after_move()
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)
