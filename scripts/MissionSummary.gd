extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var parent = null
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_tree().root.get_node("Main")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display(shots, hits, kills, dead):
	if dead:
		$Label.text = "Mission Failed"
	else:
		$Label.text = "Kills: %d Hits: %d Shots: %d" % [kills, hits, shots]
	var viewRect = parent.get_viewport_rect() 
	#$Label2.rect_position.x = -(viewRect.size.x - $Label2.rect_size.x) / 2
	#$Label2.rect_position.y = viewRect.size.y / 2
