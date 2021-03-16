extends Control

# Path Variables
var dialogue_path = ""

# text effect variables
var char_wait_time = 0.2

var dialogue_commands = {
	"shk" : ["[shake rate=60 level=10]","[/shake]"],
	"p=l" : ["wait",0.1],
	"p=m" : ["wait",0.2],
	"p=h" : ["wait",0.5],
	"" : ["wait",0.5],
	"p=e" : ["wait",1],
	"p=p" : ["wait",3],
	"CLR" : ["clear","clear"]
}

# Track dialogue variables
var dialogue

onready var LABEL : Node = $Chat/Text
onready var CHATBG : Node = $Chat/ChatBackground
onready var CHAT : Node = $Chat/ChatBox

onready var PLAYER_LABEL : Node = $PlayerLabel
onready var ENEMY_LABEL : Node = $EnemyLabel
onready var PLAYER_NAME : Node = $PlayerLabel/Text
onready var ENEMY_NAME : Node = $EnemyLabel/Text

func _ready():
	pass
	#typewrite("||w||a||i||t||.||.||.|p=p||CLR| WHO ARE YOU?? ||HELLO ??|| HELP ME THIS GUY TRAPPED ME IN THIS GAME AND NOW IS CALLING ME HIS DIALOGUE SYSTEM CAN SOMEONE HELP ME?")

func write(dlg):
	var writting = true
	while writting:
		pass
	

# X G H
func typewrite(phrase,time=0.02):
	phrase = phrase.split("|")
	var command = true
	var execution
	var k
	for i in phrase:
		command = !command
		if command:
			k = i.substr(3,len(i))
			execution = dialogue_commands[i.substr(0,3)]
			if execution[0] == "wait":
				yield(get_tree().create_timer(execution[1]),"timeout")
			elif execution[1] == "clear":
				clear()
			else:
				append(execution[0])
				append(execution[1])
		else:
			k = i
		for j in k:
			if command:
				LABEL.bbcode_text = LABEL.bbcode_text.substr(0,len(LABEL.bbcode_text)-len(execution[1]))\
				+ j + execution[1]
			else:
				append(j)
			yield(get_tree().create_timer(time),"timeout")
	
#func typewrite(phrase,time=0.02): # append letters with delay between each addition
#	for i in phrase:
#		if i != char_wait:
#			append(i)
#		else:
#			yield(get_tree().create_timer(char_wait_time), "timeout")
#		yield(get_tree().create_timer(time), "timeout")

# example: try running commandTypewrite("[shake rate=20 level=10]","OBJECTION!!!","[/shake]")
func commandTypewrite(start,phrase,end,time=0.02): # append letters between style brackets
	var size = len(end)
	append(start)
	append(end)
	for i in phrase:
		LABEL.bbcode_text = LABEL.bbcode_text.substr(0,len(LABEL.bbcode_text)-size) + i + end
		yield(get_tree().create_timer(time), "timeout")

func clear(): # clear all text
	LABEL.bbcode_text = ""

func overwrite(phrase): # instantly write a phrase, overwriting all text
	LABEL.bbcode_text = phrase
	
func append(phrase): # instantly write a phrase, appending to the end of the text
	LABEL.bbcode_text += phrase

func only_text(): # call this function to hide the Chat and ChatBackground
	CHAT.hide()
	CHATBG.hide()

func setPlayerName(name):
	PLAYER_NAME.bbcode_text = "[center]" + name + "[/center]"

func setEnemyName(name):
	ENEMY_NAME.bbcode_text = "[center]" + name + "[/center]"

func hidePlayerName():
	PLAYER_LABEL.hide()

func hideEnemyName():
	ENEMY_LABEL.hide()

func showEnemyName():
	ENEMY_LABEL.show()

func showPlayerName():
	PLAYER_LABEL.show()	
