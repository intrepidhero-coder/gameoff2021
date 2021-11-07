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

# Called when the node enters the scene tree for the first time.
func _ready():
	#position.x = get_viewport().size.x / 2
	#position.y = get_viewport().size.y / 2
	pass

func reset():
	velocity = Vector2()
	accel = Vector2()
	thrust = 1000
	attitude = 0
	max_health = 100
	health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func pewpewdie():
	if not $PewPewCoolDown.is_stopped():
		return
	$PewPewCoolDown.start()
	var root = get_tree().root
	var newBullet = get_node("../PewPewBullet").create_instance()
	root.add_child(newBullet)
	newBullet.world_position.x = world_position.x
	newBullet.world_position.y = world_position.y
	newBullet.velocity = Vector2(sin(attitude), -cos(attitude)) * newBullet.speed
	newBullet.rotation = attitude
	newBullet.speed = 1000
	newBullet.collision_layer = 0b100000000
	newBullet.collision_mask = 1
	newBullet.show()
	# TODO: add to a group

func _process(delta):
	var player = get_node("../Player")
	if health > 0:
		var a = 0
		var heading = world_position.angle_to_point(player.world_position)
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
		#a = thrust
		#pewpewdie()
		rotation = attitude
		if a != 0:
			accel = Vector2(-sin(attitude), cos(attitude)) * a * delta
			velocity += accel
		# clamp velocity at max absolute value
		if velocity.length() > 500:
			velocity = velocity.normalized() * 500
		world_position += velocity * delta
	position = world_position - get_node("../Player").world_position

func _on_Player_area_entered(area):
	#$CollisionShape2D.set_deferred("disabled", true)
	health -= area.damage
	if health <= 0:
		die()
		
func die():
	velocity.x = 0
	velocity.y = 0
	$ExplosionParticles.emitting = true
	$DeathTimer.start()
	$CollisionShape2D.set_deferred("disabled", true)
	
func _on_DeathTimer_timeout():
	$DeathTimer.stop()
	queue_free()

func _on_PewPewCoolDown_timeout():
	$PewPewCoolDown.stop()
