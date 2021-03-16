extends Control

signal out_of_time

onready var TIMEBAR : Node = $TimeBar
var playing = false
var max_size

func _ready():
	TIMEBAR.hide()
	max_size = TIMEBAR.margin_right

func start(time,time_step=0.01):
	playing = true
	TIMEBAR.show()
	var step = max_size*time_step/time
	while playing:
		TIMEBAR.margin_right -= step
		yield(get_tree().create_timer(time_step),"timeout")
		if TIMEBAR.margin_right <= 0:
			playing = false
			emit_signal("out_of_time")
			
func stop():
	playing = false
	TIMEBAR.hide()
	TIMEBAR.margin_right = max_size
