extends Node2D
 
const MENU = 0
const GAME = 1
const PAUSE = 2
const BRIEF = 3
const MISSION_MENU = 4

var state = MENU
var chosen_scenario = 0
var scenario_conditions = [
	preload("res://missions/training.gd"),
	preload("res://missions/mission1.gd")
]
var scenario_elapsed_time = 0
var scenario = null

func reset_scenario():
	chosen_scenario = 0
	scenario_elapsed_time = 0
	scenario = null

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
		get_tree().paused = true
	elif state == PAUSE:
		$GameMenu.hide()
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
		get_tree().paused = false
	elif state == PAUSE:
		$GameMenu.show()
	elif state == BRIEF:
		$Briefing.speech = scenario.speech
		$Briefing.reset()
		$Briefing.show()

func setup_scenario(which: int):
	chosen_scenario = which
	scenario = scenario_conditions[chosen_scenario].new()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# process input
	get_input()
	# update background
	if state == GAME:
		$ParallaxBackground.scroll_offset = -$Player.world_position
	elif state == MENU or state == MISSION_MENU or state == BRIEF:
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
	for event in scenario.events:
		var trigger = false
		if event["triggered"]:
			# skip old events
			continue
		# determine if the event should be triggered
		if "time" in event["after"] and scenario_elapsed_time >= event["after"]["time"]:
			trigger = true
		elif "group" in event["after"]:
			if event["after"]["group"] == "Player":
				if "position" in event["after"] and $Player.world_position.distance_to(event["after"]["position"]) < 200:
					trigger = true
				elif "target" in event["after"]:
					if $Player.target and event["after"]["target"] in $Player.target.get_groups():
						trigger = true
			else:
				var group = get_tree().get_nodes_in_group(event["after"]["group"])
				# avoid check on groups that haven't been spawned yet
				if len(group) > 0:
					var flag = true
					for n in group:
						if "dead" in event["after"] and not n.dead:
							flag = false
							break
					trigger = flag
		if trigger:
			event["triggered"] = true
			if event["kind"] == "spawn":
				spawn_event(event)
			elif event["kind"] == "win":
				# TODO: add mission summary
				end_mission()
				setup_state(MENU)
			elif event["kind"] == "message":
				$HUD.showMessage(event["message"])
	scenario_elapsed_time += 1

func spawn_event(event):
	for f in range(event["number"]):
		var s = get_node(event["scene"]).create_instance()
		var offset = Vector2(0, 0)
		if event["number"] > 1:
			offset = Vector2(randf() * 128 - 64, randf() * 128 - 64)
		for g in event["groups"]:
			s.add_to_group(g)
		s.add_to_group("mission_despawn")
		if "args" in event:
			s.init(event["position"] + offset, event["args"])
		else:
			s.init(event["position"] + offset)
		s.show()
		add_child(s)

func _on_MissionResultTimer_timeout():
	setup_state(MENU)
	
func quit():
	get_tree().quit()
	
func end_mission():
	$ScenarioEventTimer.stop()
	$Player.hide()
	$Player.reset()
	$HUD.reset()
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
	$HUD.reset()
	$HUD.show()
	$HUD.start()

