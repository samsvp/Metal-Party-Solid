extends Control

var SFX
var dialogue

# Child Nodes
onready var AUDIO : Node = $AudioStreamPlayer
onready var DIALOGUE : Node = $DialogueSystem
onready var ENEMY : Node = $Enemy
onready var PLAYER : Node = $Player
onready var FLOATING_TEXT : Node = $FloatingDialogue/Text
onready var CLOCK : Node = $Clock

# SPRITES
var playerIdle = preload("res://icon.png")
var enemyIdle = preload("res://icon.png")

# FUNCTIONS 
func _ready():
	randomize()
	stop()
	playerSprite("idle")
	enemySprite("idle")
	DIALOGUE.hideEnemyName()
	DIALOGUE.hidePlayerName()
	DIALOGUE.setEnemyName("ABCDABCDABCDABCD")
	DIALOGUE.setPlayerName("Jonh Joker")
	DIALOGUE.showPlayerName()
	DIALOGUE.showEnemyName()
	
	yield(get_tree().create_timer(2),"timeout")
	start()
	flash(1)
	CLOCK.start(3)
	floatingText(" HE'S CRAZY ")
	shakeSprite(ENEMY)
	yield(DIALOGUE.typewrite("|shkBLOOD FOR THE BLOOD GOD||||shk BLOOD FOR THE BLOOD GOD||||shk BLOOD FOR THE BLOOD GOD|"),"completed")
	flash(1)
	dialogueSay("|CLR|I'm fine now...")
	floatingText()
	#CLOCK.stop()

func start():
	self.show()

func stop():
	self.hide()
	
func loadDialogue(path,id):
	var file = File.new()
	file.open(path,file.READ)
	var json = file.get_as_text()
	dialogue = JSON.parse(json).result
	dialogue = dialogue[id]
	file.close()

func dialogueSay(dlg):
	DIALOGUE.show()
	DIALOGUE.typewrite(dlg)

func dialogueAsk(dlg):
	DIALOGUE.show()

func SFX(stream):
	var audio = AudioStreamPlayer.new()
	audio.set_stream(stream)
	audio.play(0.0)
	yield(audio,"finished")
	remove_child(audio)

func shakeSprite(AnimSprite,power=10,time=2,step=0.02):
	var pos = ENEMY.offset
	for i in range(time/step):
		AnimSprite.offset = pos + rVector2(power)
		yield(get_tree().create_timer(step),"timeout")
	AnimSprite.offset = pos

func rVector2(max_range):
	return Vector2(randi()%max_range,randi()%max_range)

func flash(time,steps=20.0):
	var flash_screen = ColorRect.new()
	add_child(flash_screen)
	flash_screen.margin_bottom = 600
	flash_screen.margin_top = -600
	flash_screen.margin_right = 600
	flash_screen.margin_left = -600
	flash_screen.color = Color(1,1,1,1)
	var step = 1/steps
	var time_step = time*step
	for i in range(steps):
		flash_screen.color = Color(1,1,1,1-i*step)
		yield(get_tree().create_timer(time_step),"timeout")
	remove_child(flash_screen)

func playerSprite(st):
	PLAYER.texture = {
		"idle" : playerIdle
	}[st]

func enemySprite(st):
	ENEMY.texture = {
		"idle" : enemyIdle
	}[st]

func floatingText(st=""):
	st = "[center] [shake rate=20 level=30]" + st + "[/shake] [/center]"
	FLOATING_TEXT.bbcode_text = st
