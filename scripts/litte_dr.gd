extends Area2D


export (int) var speed = 1000
export var velocity = Vector2()
export var damage = 10
export var world_position = Vector2()
var exploding = false
var lines = []
var gun = null
var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_STOP
	lines.append($Line0)
	for f in range(5):
		var l = $Line0.duplicate()
		lines.append(l)
		add_child(l)

func fire(gun, target):
	# fire a littleDr from gun to target (nodes with world_position)
	self.gun = gun
	self.target = target

func _process(delta):
	var player = get_node("../Player")
	if not exploding and gun and target:
		var pos0 = gun.world_position - player.world_position
		# b/c Lines are positioned relative to the parent
		# which is at the target
		var pos1 = Vector2(0, 0)
		for l in lines:
			# TODO: add orthoganol offset
			l.points[0] = pos0
			l.points[1] = pos1
		# for collision detection
		position = target.world_position - player.world_position
	else:
		#position = Vector2(0, 0)
		pass

func _on_Bullet_area_entered(area):
	# disable further collisons
	$CollisionShape2D.set_deferred("disabled", true)
	$Explosion.emitting = true
	$Sprite.hide()
	velocity.x = 0
	velocity.y = 0
	$ExplosionTimer.start()
	exploding = true

func _on_ExplosionTimer_timeout():
	queue_free()

func _on_Lifetime_timeout():
	queue_free()
