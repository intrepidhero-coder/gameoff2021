extends Area2D

signal hit

# Declare member variables here. Examples:
export var velocity = Vector2()
export var accel = Vector2()
export var thrust = 1000
export var attitude = 0
export (int) var max_health = 100
export (int) var health = max_health

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = get_viewport().size.x / 2
	position.y = get_viewport().size.y / 2

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
	var newBullet = $PewPewBullet.instance()
	newBullet.show()
	newBullet.position.x = position.x
	newBullet.position.y = position.y
	newBullet.velocity.x = sin(attitude)
	newBullet.velocity.y = -cos(attitude)
	newBullet.speed = 1000
	newBullet.collision_layer = 0b100000000
	newBullet.collision_mask = 1
	$"..".add_child(newBullet)
	# TODO: add to a group

func _process(delta):
	if health > 0:
		var a = 0
		if Input.is_action_pressed("right"):
			attitude += (2*PI) * delta
		if Input.is_action_pressed("left"):
			attitude -= (2*PI) * delta
		if Input.is_action_pressed("up"):
			a = -thrust
		elif Input.is_action_pressed("down"):
			a = thrust
		if Input.is_action_pressed("action"):
			pewpewdie()

		rotation = attitude
		if a != 0:
			accel.x = -sin(attitude)
			accel.y = cos(attitude)
			accel *= a * 1000 *delta
			velocity += accel
		# clamp velocity at max absolute value
		if velocity.length() > 300:
			velocity = velocity.normalized() * 300

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
	$"..".setup_state($"..".MENU)

func _on_PewPewCoolDown_timeout():
	$PewPewCoolDown.stop()
