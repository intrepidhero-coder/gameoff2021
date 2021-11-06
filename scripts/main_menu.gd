extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_tree().root.get_node("Main")
	rect_size.x = parent.get_viewport_rect().size.x
	rect_size.y = parent.get_viewport_rect().size.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	# TODO: keyboard navigation
#	pass


func _on_Select_pressed():
	# TODO: mission menu
	parent.setup_state(parent.GAME)

func _on_Quit_pressed():
	parent.quit()
