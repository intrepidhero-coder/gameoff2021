extends ReferenceRect

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

var parent = null
var queen_sprite = null
var player_sprite = null

# Called when the node enters the scene tree for the first time.
func _ready():
	#reset()
	parent = get_tree().root.get_node("Main")
	rect_size.x = parent.get_viewport_rect().size.x
	rect_size.y = parent.get_viewport_rect().size.y
	rect_position = -parent.get_viewport_rect().size / 2
	#position = -parent.get_viewport_rect().size / 2
	queen_sprite = $VBoxContainer1/Control2/Queen
	player_sprite = $VBoxContainer2/Control1/Player
	
func _process(delta):
	if parent.state == parent.BRIEF:
		if Input.is_action_just_pressed("escape"):
			advance_speech()
	
func done():
	$PlayerTimer.stop()
	$QueenTimer.stop()
	$SpeechTimer.stop()
	$AnimationPlayer.play("Fade")
	yield($AnimationPlayer, "animation_finished")
	parent.setup_state(parent.GAME)

func reset():
	current_line = -1
	$ColorRect.color = Color(0, 0, 0, 0)
	advance_speech()
	$SpeechTimer.start()
	$PlayerTimer.start()
	$QueenTimer.start()

func advance_speech():
	current_line += 1
	if current_line >= len(speech):
		done()
	else:
		$VBoxContainer2/PlayerRichTextLabel.text = ""
		$VBoxContainer1/QueenRichTextLabel.text = ""
		which_talking = speech[current_line][0]
		var line = speech[current_line][1]
		if which_talking == QUEEN:
			$VBoxContainer1/QueenRichTextLabel.text = line
		else:
			$VBoxContainer2/PlayerRichTextLabel.text = line
		change_animation(queen_sprite, which_talking == QUEEN)	
		change_animation(player_sprite, which_talking == PLAYER)
		$SpeechTimer.wait_time = len(speech[current_line][1]) / 5

func change_animation(node, talking):
	if node.frame == 0:
		var possible = idle_poses
		if talking:
			possible = talking_poses
		var i = randi() % len(possible)
		node.play(possible[i])

func _on_PlayerTimer_timeout():
	change_animation(player_sprite, which_talking == PLAYER)

func _on_QueenTimer_timeout():
	change_animation(queen_sprite, which_talking == QUEEN)

func _on_SpeechTimer_timeout():
	advance_speech()
