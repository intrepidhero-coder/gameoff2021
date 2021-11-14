extends Node2D
 
const MENU = 0
const GAME = 1
const PAUSE = 2
const BRIEF = 3
const MISSION_MENU = 4

var state = MENU
var chosen_scenario = 0
var scenario_conditions = [
	preload("res://missions/mission1.gd").new()
]
var scenario_elapsed_time = 0

func reset_scenario():
	chosen_scenario = 0
	scenario_elapsed_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# load the scenarios
	reset_scenario()
	setup_state(MENU)

# call this on state transitions
func setup_state(newstate):
	# tear down old state
	if state == MENU:
		$MainMenu.hide()
	elif state == MISSION_MENU:
		$MissionMenu.hide()
	elif state == GAME:
		pass
	elif state == PAUSE:
		$GameMenu.hide()
		get_tree().paused = false
	elif state == BRIEF:
		$Briefing.hide()
		start_mission()
	# setup the new state
	state = newstate
	if state == MENU:
		$MainMenu.show()
	elif state == MISSION_MENU:
		$MissionMenu.show()
	elif state == GAME:
		pass
	elif state == PAUSE:
		get_tree().paused = true
		$GameMenu.show()
	elif state == BRIEF:
		$Briefing.speech = scenario_conditions[chosen_scenario].speech
		$Briefing.reset()
		$Briefing.show()

func setup_scenario(scenario: int):
	chosen_scenario = scenario

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# process input
	get_input()
	# update background
	if state == GAME:
		$ParallaxBackground.scroll_offset = -$Player.world_position
	elif state == MENU or state == MISSION_MENU:
		var scroll = Vector2(0, 2)
		$ParallaxBackground.scroll_offset += scroll
	elif state == PAUSE:
		pass

func get_input():
	if state == MENU or state == MISSION_MENU:
		pass
	elif state == GAME:
		if Input.is_action_just_pressed("escape"):
			setup_state(PAUSE)
	elif state == PAUSE:
		if Input.is_action_just_pressed("escape"):
			setup_state(GAME)
	elif state == BRIEF:
		pass

# checks for scenario events
func _on_ScenarioEventTimer_timeout():
	var scenario = scenario_conditions[chosen_scenario]
	if scenario_elapsed_time in scenario.events:
		var event = scenario.events[scenario_elapsed_time]
		if event["kind"] == "spawn":
			for f in range(event["number"]):
				var s = get_node(event["scene"]).create_instance()
				var offset = Vector2(randf() * 128 - 64, randf() * 128 - 64)
				for g in event["groups"]:
					s.add_to_group(g)
				s.add_to_group("mission_despawn")
				if "args" in event:
					s.init(event["position"] + offset, event["args"])
				else:
					s.init(event["position"] + offset)
				s.show()
				add_child(s)
	scenario_elapsed_time += 1

func _on_MissionResultTimer_timeout():
	setup_state(MENU)
	
func quit():
	get_tree().quit()
	
func end_mission():
	$ScenarioEventTimer.stop()
	$Player.hide()
	$Player.reset()
	$HUD.hide()
	reset_scenario()
	# despawn any left over entities
	for node in get_tree().get_nodes_in_group("mission_despawn"):
		node.queue_free()

func start_mission():
	# start scenario timer (for checking conditions)
	$ScenarioEventTimer.start()
	# reset the player
	$Player.reset()
	$Player.show()
	$HUD.show()

