extends Node2D

# Actors
const QUEEN = 1
const PLAYER = 2
var which_talking = QUEEN
var speech = [
	[QUEEN, "To be or not to be"],
	[PLAYER, "That is the question"],
	[QUEEN, "Whether tis nobler in mind"],
	[PLAYER, "To bear the slings and arrows"],
	[PLAYER, "(whispers) of outrageous fortune"],
	[QUEEN, "..."],
	[PLAYER, "(whispers loudly) of outrageous fortune!"],
	[QUEEN, "THIS IS A STUPID PLAY!"],
	[QUEEN, "If my uncle murdered my dad and married my mom I would eat them all!"]
]
var current_line = 0

var talking_poses = ["idle", "antenna", "arms", "blink", "mandibles", "tilt"]
var idle_poses = ["idle", "blink", "antenna"]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func done():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func reset():
	current_line = -1
	advance_speech()
	$SpeechTimer.start()
	$Player/PlayerTimer.start()
	$Queen/QueenTimer.start()

func advance_speech():
	current_line += 1
	if current_line >= len(speech):
		done()
	else:
		$PlayerRichTextLabel.text = ""
		$QueenRichTextLabel.text = ""
		which_talking = speech[current_line][0]
		var line = speech[current_line][1]
		if which_talking == QUEEN:
			$QueenRichTextLabel.text = line
		else:
			$PlayerRichTextLabel.text = line
		change_animation($Queen, which_talking == QUEEN)	
		change_animation($Player, which_talking == PLAYER)
		$SpeechTimer.wait_time = len(speech[current_line][1]) / 5

func change_animation(node, talking):
	if node.frame == 0:
		var possible = idle_poses
		if talking:
			possible = talking_poses
		var i = randi() % len(possible)
		node.play(possible[i])

func _on_PlayerTimer_timeout():
	change_animation($Player, which_talking == PLAYER)

func _on_QueenTimer_timeout():
	change_animation($Queen, which_talking == QUEEN)

func _on_SpeechTimer_timeout():
	advance_speech()
