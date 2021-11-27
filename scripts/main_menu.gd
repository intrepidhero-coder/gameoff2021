extends Control


var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_tree().root.get_node("Main")
	rect_size.x = parent.get_viewport_rect().size.x
	rect_size.y = parent.get_viewport_rect().size.y
	rect_position = -parent.get_viewport_rect().size / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	# TODO: keyboard navigation
#	pass


func _on_Select_pressed():
	parent.setup_state(parent.MISSION_MENU)

func _on_Quit_pressed():
	parent.quit()

func _on_Test_Mode_pressed():
	parent.setup_scenario(1)
	parent.start_mission()
	parent.setup_state(parent.GAME)
	$"../Player".god_mode = true
