extends Node2D
 
const MENU = 0
const GAME = 1
const PAUSE = 2
const BRIEF = 3

var state = MENU
var chosen_scenario = 1
var scenario_conditions = [preload("res://missions/mission1.gd")]
var scenario_elapsed_time = 0

func reset_scenario():
	chosen_scenario = 1
	scenario_conditions = null
	scenario_elapsed_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# load the scenarios
	setup_state(MENU)

# call this on state transitions
func setup_state(newstate):
	# tear down old state
	if state == MENU:
		# hide the main menu
		$MainMenu.hide()
	elif state == GAME:
		# dequeue player, baddies, bullets, allies
		$Player.hide()
		# get_tree().get_nodes_in_group("blah")
		reset_scenario()
	elif state == PAUSE:
		# unpause the tree
		# hide the in game menu
		pass
	elif state == BRIEF:
		pass
	# setup the new state
	state = newstate
	if state == MENU:
		$MainMenu.show()
		# set the camera position?
	elif state == GAME:
		# start scenario timer (for checking conditions)
		$ScenarioEventTimer.start()
		# reset the player
		$Player.reset()
		$Player.show()
	elif state == PAUSE:
		# pause the tree (except background)
		# load the in game menu
		pass
	elif state == BRIEF:
		pass

func setup_scenario(scenario):
	# load scenario from json
	# instance all nodes
	# hide or show as appropriate
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# update background
	if state == GAME:
		var scroll = -$Player.velocity / 200
		$ParallaxBackground.scroll_offset += scroll
	elif state == MENU:
		var scroll = Vector2(0, 2)
		$ParallaxBackground.scroll_offset += scroll
	elif state == PAUSE:
		pass

func get_input():
	pass

# checks for scenario events
func _on_ScenarioEventTimer_timeout():
	pass # Replace with function body.

func _on_MissionResultTimer_timeout():
	setup_state(MENU)
	
func quit():
	get_tree().quit()

