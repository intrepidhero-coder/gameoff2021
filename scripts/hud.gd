extends MarginContainer


var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_tree().root.get_node("Main")
	rect_size.x = parent.get_viewport_rect().size.x
	rect_size.y = parent.get_viewport_rect().size.y
	rect_position = -parent.get_viewport_rect().size / 2

func set_health(x):
	$HBoxContainer/MarginContainer/HBoxContainer/Health.value = x

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
