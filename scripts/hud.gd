extends Node2D


var parent
var player
var bad_blip = preload("res://assets/sensor_red.png")
var neutral_blip = preload("res://assets/sensor_blue.png")
var ally_blip = preload("res://assets/sensor_green.png")
var blips = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"../Player"
	parent = get_tree().root.get_node("Main")
	var viewRect = parent.get_viewport_rect() 
	#rect_size = viewRect.size
	$TextureRect.rect_position = -viewRect.size / 2
	$Health.rect_position.x = -viewRect.size.x / 2 + $TextureRect.rect_size.x
	$Health.rect_position.y = -viewRect.size.y / 2
	$Sensor.rect_position.x = -viewRect.size.x / 2
	$Sensor.rect_position.y = viewRect.size.y / 2 - 196
	$Computer.rect_position = viewRect.size / 2 - $Computer.rect_size

func reset():
	for b in blips.values():
		b.queue_free()
	blips = {}

func set_health(x):
	$Health.value = x

func calc_pos(node):
	var relative_pos = node.world_position - player.world_position
	return relative_pos.clamped(2000) / 2000 * 92 + $Sensor.rect_position + $Sensor.rect_size / 2
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# update the sensor
	for n in get_tree().get_nodes_in_group("neutral"):
		if not n in blips:
			var b = Sprite.new()
			b.texture = neutral_blip
			blips[n]  = b
			add_child(b)
	for n in get_tree().get_nodes_in_group("allies"):
		if not n in blips:
			var b = Sprite.new()
			b.texture = ally_blip
			blips[n]  = b
			add_child(b)
	for n in get_tree().get_nodes_in_group("baddies"):
		if not n in blips:
			var b = Sprite.new()
			b.texture = bad_blip
			blips[n]  = b
			add_child(b)
	for n in blips.keys():
		var b = blips[n]
		if not n.dead:
			b.position = calc_pos(n)
		else:
			blips.erase(n)
			b.queue_free()
