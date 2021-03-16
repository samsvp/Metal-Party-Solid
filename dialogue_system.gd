extends Control

# Node references
onready var spriteLeft : Node = $Center/SpriteLeft
onready var spriteRight : Node = $Center/SpriteRight

onready var rightNameLabel : Node = $Chat/RightName
onready var leftNameLabel : Node = $Chat/LeftName

onready var op1 : Node = $Chat/Options/Op1
onready var op2 : Node = $Chat/Options/Op2
onready var op3 : Node = $Chat/Options/Op3
onready var ops : Node = $Chat/Options

onready var text : Node = $Chat/Text

onready var tween : Node = $Tween

# Path variables
var dialogue_path = "res://assets/dialogues"
# Node instances
var dynamicBars = []

# standard variables
var standard_frame_H = 1
var standard_frame_V = 1

# dialogue variables
var time_to_answer = 5
var timerSizePerSecond = 200

var dialogue
var font = preload("res://DotGothic_DynamicFont.tres")
var font_small = preload("res://DotGothic_DynamicFont_Small.tres")

# question variables
var question = false
var question_select = 0
var answer_given = false
signal answer_timeout

func _ready():
	self.hide()
	#dynamicBar(0.1,0.1,0.3,Color(0.8,0.8,0.1,0.8),400,"Akwardtometer")

#	floatingText(" awkward ",0.01,0.02,0.05,0.12,font_small)
#	dynamicBar(0.13,0.035,0.02,Color(0.9,0.2,0.6,0.8),0,"awkward")
#
#	floatingText(" boring ",0.01,0.055,0.05,0.12,font_small)
#	dynamicBar(0.13,0.070,0.02,Color(0.5,0.5,0.5,0.8),0,"boring")
#
#	floatingText(" annoying ",0.01,0.090,0.05,0.12,font_small)
#	dynamicBar(0.13,0.105,0.02,Color(0.9,0.5,0.1,0.8),0,"annoying")

	dynamicBar(0.00,0.65,0.02,Color(1,1,1,0.5),0,"timer")

	start("test",200,300,100)


func _process(delta):

	# update the dynamicbars color_rects
	for i in dynamicBars:
		i[0].margin_right = i[1]

	# check if timer has run out
	var timer = getDynamicBar("timer")
	if timer and question:
		addDynamicBarValue("timer",-delta*timerSizePerSecond)
		if timer[1] <= 0:
			emit_signal("answer_timeout")

	if Input.is_action_just_pressed("ui_up"):
		question_select += 1
		question_select %= 3
	elif Input.is_action_just_pressed("ui_down"):
		question_select -= 1
		question_select %= 3
	elif Input.is_action_just_pressed("ui_accept"):
		answer_given = true

func start(file,akward,boring,annoying):
	loadDialogue(file)
	self.show()

	getDynamicBar("awkward")[1] = akward
	getDynamicBar("boring")[1] = boring
	getDynamicBar("annoying")[1] = annoying

	if dialogue["spriteLeft"]:
		startSprite(
			spriteLeft,
			load(dialogue["spriteLeft"]),
			Vector2(-600,0),Vector2(-400,0),1
		)
	if dialogue["spriteRight"]:
		startSprite(
			spriteRight,
			load(dialogue["spriteLeft"]),
			Vector2(600,0),Vector2(400,0),1
		)
	yield(tween,"tween_all_completed")


func stop():
	self.hide()
	spriteLeft.texture = null
	spriteRight.texture = null

########################
## DIALOGUE FUNCTIONS ##
########################

func smartWrite(st):
	var writting_command = false
	var command = ""
	for i in st:
		if i == "<":
			writting_command = true
			command = ""
		elif i == ">":
			writting_command = false
			command = command.substr(1,len(command))
			command = command.split(":")
			{
			“E” : effect(command[1]),
			“T” : ftext(command[1],command[2],command[3]),
			“C” : clear(),
			“F” : flash(command[1]),
			“S” : shake(),
			“SP” : shake(spriteLeft),
			“SE” : shake(spriteRight),
			“A” : hp(command[1],command[2],command[3],command[4]),
			“J” : sfx(command[0]),
			}[command[0]]

		if writting_command:
				command += i 
		  else:
				# Do stuff as normal
				#

func loadDialogue(id):
	var file = File.new()
	file.open('%s/%s.json' % [dialogue_path, id], file.READ)
	var json = file.get_as_text()
	dialogue = JSON.parse(json).result
	file.close()

func startSprite(sprite_obj,texture,initial_Vector2,final_Vector2,time,H=standard_frame_H,V=standard_frame_V):
	sprite_obj.hframes = H
	sprite_obj.vframes = V
	sprite_obj.texture = texture
	sprite_obj.show()
	tween.interpolate_property(sprite_obj,"position",initial_Vector2,final_Vector2,time,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()

func dynamicBar(x,y,H,color,value,name):
	var bar = ColorRect.new()
	bar.anchor_left = x
	bar.anchor_right = x
	bar.anchor_top = y
	bar.anchor_bottom = y + H 
	bar.margin_right = value
	bar.color = color
	self.add_child(bar)
	dynamicBars.append([bar,value,name])

func getDynamicBar(name):
	for i in dynamicBars:
		if i[2] == name:
			return i
	return null

func addDynamicBarValue(name,val):
	getDynamicBar(name)[1] += val

func floatingText(text,x,y,H,S,_font,time=null,center=true):
	var txt = RichTextLabel.new()
	txt.anchor_left = x
	txt.anchor_right = x + S
	txt.anchor_top = y
	txt.anchor_bottom = y + H
	txt.add_font_override("normal_font",_font)
	txt.bbcode_enabled = true
	if center:
		txt.bbcode_text = "[center]" + text + "[/center]"
	else:
		txt.bbcode_text = text

	self.add_child(txt)
	if time:
		yield(get_tree().create_timer(time), "timeout")
		self.remove_child(txt)

func askQuestion(options):
	answer_given = false
	question = true
	var keys = options.keys()
	op1.bbcode_text = keys[0]
	op2.bbcode_text = keys[1]
	op3.bbcode_text = keys[2]
	ops.show()
	# start the timer bar
	getDynamicBar("timer")[1] = time_to_answer*timerSizePerSecond

	# wait for answer_timeout
	yield(self,"answer_timeout")
	if answer_given:
		return answerQuestion(question_select,options)
	else:
		return answerQuestion(0,options)

func answerQuestion(n,options):
	question = false
	ops.hide()
	return options[{
		0 : "timeout",
		1 : op1.bbcode_text,
		2 : op2.bbcode_text,
		3 : op3.bbcode_text
	}[n]]

func typeWrite(txt):
	text.bbcode_text = txt
