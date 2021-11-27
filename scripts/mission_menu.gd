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
#	pass

func _on_Back_pressed():
	parent.setup_state(parent.MENU)

func _on_Select1_pressed():
	parent.setup_scenario(0)
	parent.setup_state(parent.BRIEF)

func _on_Select2_pressed():
	parent.setup_scenario(1)
	parent.setup_state(parent.BRIEF)
