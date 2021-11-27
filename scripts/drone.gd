extends Area2D

signal hit

# Declare member variables here. Examples:
export var velocity = Vector2()
export var accel = Vector2()
export var thrust = 200
export var attitude = 0
export (int) var max_health = 100
export (int) var health = max_health
export var world_position = Vector2()
var dead = false
var controller = null
var virtual = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#position.x = get_viewport().size.x / 2
	#position.y = get_viewport().size.y / 2
	pause_mode = Node.PAUSE_MODE_STOP

func init(pos, args := null):
	reset()
	world_position = pos

func reset():
	velocity = Vector2()
	accel = Vector2()
	thrust = 400
	attitude = 0
	max_health = 100
	health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func pewpewdie():
	if not $PewPewCoolDown.is_stopped():
		return
	$PewPewCoolDown.start()
	#$AudioStreamPlayer2D.play()
	var root = get_tree().root
	var newBullet = get_node("../PewPewBullet").create_instance()
	newBullet.setSprite(1)
	newBullet.collision_layer = 256
	newBullet.collision_mask = 2
	newBullet.world_position.x = world_position.x
	newBullet.world_position.y = world_position.y
	newBullet.position = newBullet.world_position - get_node("../Player").world_position
	var a = attitude - PI/2
	newBullet.velocity = Vector2(sin(a), -cos(a)) * newBullet.speed
	newBullet.rotation = a
	newBullet.speed = 1000
	newBullet.damage = 5
	root.add_child(newBullet)
	newBullet.add_to_group("mission_despawn")
	newBullet.show()
	# TODO: add to a group

func _process(delta):
	var target = null
	var player = get_node("../Player")
	if controller:
		if controller.target:
			if not controller.target.dead:
				target = controller.target.world_position
	if health > 0 and target:
		var a = 0
		var heading = world_position.angle_to_point(target)
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
		var d = world_position.distance_to(target)
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
		if velocity.length() > 300:
			velocity = velocity.normalized() * 300
		world_position += velocity * delta
	position = world_position - player.world_position
		
func die():
	dead = true
	$Sprite.hide()
	$ExplosionParticles.emitting = true
	$DeathTimer.start()
	$CollisionShape2D.set_deferred("disabled", true)
	
func _on_DeathTimer_timeout():
	$DeathTimer.stop()
	$ExplosionParticles.emitting = false
	#queue_free()

func _on_PewPewCoolDown_timeout():
	$PewPewCoolDown.stop()
	#$AudioStreamPlayer2D.stop()

func _on_Drone_area_shape_entered(area_id, area, area_shape, local_shape):
	health -= area.damage
	if health <= 0:
		die()
