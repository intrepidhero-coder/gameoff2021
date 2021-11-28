extends Area2D

signal hit

# Declare member variables here. Examples:
export var velocity = Vector2()
export var accel = Vector2()
export var thrust = 200
export var attitude = 0
export var max_v = 300
export (int) var max_health = 100
export (int) var health = max_health
export var world_position = Vector2()
var dead = false
var virtual = false
var ico = "Baddie"
var target_group = "allies"

# Called when the node enters the scene tree for the first time.
func _ready():
	#position.x = get_viewport().size.x / 2
	#position.y = get_viewport().size.y / 2
	pause_mode = Node.PAUSE_MODE_STOP
	
func init(pos, args):
	reset()
	world_position = pos
	if args and "fixed_target" in args:
		target_group = args["fixed_target"]

func reset():
	velocity = Vector2()
	accel = Vector2()
	thrust = 200
	attitude = 0
	max_health = 100
	health = max_health
	target_group = "allies"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func pewpewdie():
	if not $PewPewCoolDown.is_stopped():
		return
	$PewPewCoolDown.start()
	$AudioStreamPlayer2D.play()
	var root = get_tree().root
	var newBullet = get_node("../PewPewBullet").create_instance()
	newBullet.collision_layer = 512
	newBullet.collision_mask = 1
	newBullet.world_position.x = world_position.x
	newBullet.world_position.y = world_position.y
	newBullet.position = newBullet.world_position - get_node("../Player").world_position
	var a = attitude - PI/2
	newBullet.velocity = Vector2(sin(a), -cos(a)) * newBullet.speed
	newBullet.rotation = a
	newBullet.speed = 1000
	root.add_child(newBullet)
	newBullet.add_to_group("mission_despawn")
	newBullet.show()
	# TODO: add to a group

func _process(delta):
	var player = get_node("../Player")
	var target = player
	var nodes = get_tree().get_nodes_in_group(target_group)
	if len(nodes) == 0:
		nodes = get_tree().get_nodes_in_group("allies")
	var d = world_position.distance_to(target.world_position)
	for n in nodes:
		var d_ = world_position.distance_to(n.world_position)
		if d < 0 or d > d_:
			d = d_
			target = n
	# anti-clumping
	var neighbor_force = Vector2(0, 0)
	for member in get_tree().get_nodes_in_group("baddies"):
		if world_position.distance_to(member.world_position) < 16:
			neighbor_force += (world_position - member.world_position).normalized() * 8
	velocity += neighbor_force
	if health > 0:
		var a = 0
		var heading = world_position.angle_to_point(target.world_position)
		$Label.text = "%.2f %.2f" % [attitude, heading]
		var change = 1 # default to turn clockwise
		if heading < attitude:
			change = -1
		if abs(heading - attitude) > PI:
			change *= -1
		if abs(heading - attitude) < PI / 32:
			change = 0
		attitude += (2*PI) * delta * change
		# keep attitude between -PI and PI
		if attitude > PI:
			attitude = attitude - (2*PI)
		if attitude < -PI:
			attitude = attitude + (2*PI)
		if d > 10:
			a = thrust
		if d < 400:
			pewpewdie()
		rotation = attitude
		if a != 0:
			var theta = attitude - PI/2
			accel = Vector2(sin(theta), -cos(theta)) * a * delta
			velocity += accel
		# clamp velocity at max absolute value
		if velocity.length() > max_v:
			velocity = velocity.normalized() * max_v
		world_position += velocity * delta
	position = world_position - player.world_position
		
func die():
	dead = true
	remove_from_group("baddies")
	$Sprite.hide()
	$ExplosionParticles.emitting = true
	$AudioStreamPlayer2D2.play()
	$DeathTimer.start()
	$CollisionShape2D.set_deferred("disabled", true)
	
func _on_DeathTimer_timeout():
	$DeathTimer.stop()
	$ExplosionParticles.emitting = false
	$AudioStreamPlayer2D2.stop()
	# I was freeing these nodes but that caused problems
	# with other nodes trying to refer them for targeting
	# they should still be freed at the end of the mission
	#queue_free()

func _on_PewPewCoolDown_timeout():
	$PewPewCoolDown.stop()
	$AudioStreamPlayer2D.stop()

func _on_Baddie_area_shape_entered(area_id, area, area_shape, local_shape):
	health -= area.damage
	if area.source:
		area.source.hits += 1
	if health <= 0:
		if area.source:
			area.source.kills += 1
		die()
