extends Node2D


var parent
var player
var bad_blip = preload("res://assets/sensor_red.png")
var neutral_blip = preload("res://assets/sensor_blue.png")
var ally_blip = preload("res://assets/sensor_green.png")
var select_blip = preload("res://assets/sensor_select.png")
var ico_bad = preload("res://assets/ico_bad.png")
var ico_beacon = preload("res://assets/ico_beacon.png")
var ico_dr = preload("res://assets/ico_dr.png")
var ico_drone = preload("res://assets/ico_drone.png")
var ico_wingman = preload("res://assets/ico_wingman.png")
var ico_mother = preload("res://assets/ico_mother.png")
var name_to_ico = {"Dr": ico_dr, "Baddie": ico_bad, "Beacon": ico_beacon, "Mother": ico_mother}
var blips = {}
var bracket = null
const MARGIN = 8
var running = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"../Player"
	parent = get_tree().root.get_node("Main")
	var viewRect = parent.get_viewport_rect() 
	$TextureRect.rect_position = -viewRect.size / 2
	$Health.rect_position.x = -viewRect.size.x / 2 + $TextureRect.rect_size.x + MARGIN
	$Health.rect_position.y = -viewRect.size.y / 2
	$Sensor.rect_position.x = -viewRect.size.x / 2
	$Sensor.rect_position.y = viewRect.size.y / 2 - $Sensor.rect_size.y
	$Com.rect_position.x = $Sensor.rect_position.x + $Sensor.rect_size.x + MARGIN
	$Com.rect_position.y = viewRect.size.y / 2 - $Com.rect_size.y
	$Com.text = ""
	$Computer.rect_position = viewRect.size / 2 - $Computer.rect_size
	$Computer/Display.rect_position = ($Computer.rect_size - $Computer/Display.rect_size) / 2
	bracket = Sprite.new()
	bracket.texture = select_blip
	bracket.hide()
	add_child(bracket)

func reset():
	running = false
	for b in blips.values():
		b.queue_free()
	blips = {}
	$Com.text = ""
	
func start():
	running = true

func set_health(x):
	$Health.value = x

func calc_pos(node):
	var relative_pos = node.world_position - player.world_position
	return relative_pos.clamped(2000) / 2000 * 92 + $Sensor.rect_position + $Sensor.rect_size / 2
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not running:
		return
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
	if player.target and not player.target.dead:
		bracket.show()
		bracket.position = calc_pos(player.target)
		$Computer/Display.texture = name_to_ico[player.target.ico]
		$Computer/Display.rect_position = ($Computer.rect_size - $Computer/Display.rect_size) / 2
		$Computer/Display.show()
	else:
		bracket.hide()
		$Computer/Display.hide()

func showMessage(msg):
	$Com.text = msg
	$ComTimer.start()

func _on_ComTimer_timeout():
	# initially I thought I might use this to clear the message but while making the tutorial
	# it seemed better to allow the mission event framework to directly control the messages
	$ComTimer.stop()
