extends Area2D


export (int) var speed = 1000
export var velocity = Vector2()
export var damage = 100
export var world_position = Vector2()
var effect = false
var lines = []
var gun = null
var target = null
const HITLIMIT = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_STOP
	lines.append($Line0)
	for f in range(5):
		var l = $Line0.duplicate()
		l.default_color = Color(1.0, 1.0, 0.5 + randf()*0.4, randf() * 0.5 + 0.2)
		lines.append(l)
		add_child(l)

func fire(gun, target):
	# fire a littleDr from gun to target (nodes with world_position)
	self.gun = gun
	self.target = target

func _process(delta):
	var player = get_node("../Player")
	if gun and target:
		var pos0 = gun.world_position - target.world_position
		# b/c Lines are positioned relative to the parent
		# which is at the target
		var pos1 = Vector2(0, 0)
		for l in lines:
			# TODO: add orthogonal offset
			var r = Vector2(randi() % 12, randi() % 12)
			l.points[0] = pos0 + r
			l.points[1] = pos1 + r

		# for collision detection
		world_position = target.world_position
		position = world_position - player.world_position
	else:
		# the disentegrate effect
		#position = Vector2(0, 0)
		position = world_position - player.world_position

func _on_Bullet_area_entered(area):
	$EffectTime.start()
	# duplicate the CollisionShape (up to a limit)
	# and set the position to the target
	var d = $CollisionShape2D.duplicate()
	d.get_shape().set_radius(128)
	d.position = area.position
	add_child(d)

func _on_BeamTime_timeout():
	# start the effect animation
	for l in lines:
		l.hide()

func _on_EffectTime_timeout():
	queue_free()
