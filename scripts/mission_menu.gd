extends Control

var parent
var scores = [[0,0,0], [0,0,0], [0,0,0], [0,0,0], [0,0,0]]

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_tree().root.get_node("Main")
	rect_size.x = parent.get_viewport_rect().size.x
	rect_size.y = parent.get_viewport_rect().size.y
	rect_position = -parent.get_viewport_rect().size / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show():
	# call the parent method, in Godot 4 this becomes super.show()
	.show()
	var i = 0
	for label in [$GridContainer/Label1, $GridContainer/Label2, $GridContainer/Label3, 
		$GridContainer/Label4, $GridContainer/Label5]:
		label.text = "%d/%d/%d" % scores[i]
		i += 1
	
func _on_Back_pressed():
	parent.setup_state(parent.MENU)

func _on_Select1_pressed():
	parent.setup_scenario(0)
	parent.setup_state(parent.BRIEF)

func _on_Select2_pressed():
	parent.setup_scenario(1)
	parent.setup_state(parent.BRIEF)

func _on_Select3_pressed():
	parent.setup_scenario(2)
	parent.setup_state(parent.BRIEF)

func _on_Select4_pressed():
	parent.setup_scenario(3)
	parent.setup_state(parent.BRIEF)
	
func _on_Select5_pressed():
	parent.setup_scenario(4)
	parent.setup_state(parent.BRIEF)

