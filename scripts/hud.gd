extends Node2D


var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_tree().root.get_node("Main")
	var viewRect = parent.get_viewport_rect() 
	#rect_size = viewRect.size
	$TextureRect.rect_position = -viewRect.size / 2
	$Health.rect_position.x = -viewRect.size.x / 2 + $TextureRect.rect_size.x
	$Health.rect_position.y = -viewRect.size.y / 2
	$Sensor.rect_position.x = -viewRect.size.x / 2
	$Sensor.rect_position.y = viewRect.size.y / 2 - 196
	$Computer.rect_position = viewRect.size / 2 - $Computer.rect_size

func set_health(x):
	$Health.value = x

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
