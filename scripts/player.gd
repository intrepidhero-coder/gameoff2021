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
var god_mode = false
var target = null
var last_target = 0

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
	$Sprite.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func pewpewdie():
	if not $PewPewCoolDown.is_stopped():
		return
	$PewPewCoolDown.start()
	$AudioStreamPlayer2D.play()
	var root = get_tree().root
	var newBullet = get_node("../PewPewBullet").create_instance()
	newBullet.setSprite(1)
	newBullet.world_position.x = world_position.x
	newBullet.world_position.y = world_position.y
	newBullet.velocity = Vector2(sin(attitude), -cos(attitude)) * newBullet.speed
	newBullet.rotation = attitude
	newBullet.speed = 1000
	newBullet.collision_layer = 256
	newBullet.collision_mask = 2
	root.add_child(newBullet)
	newBullet.add_to_group("mission_despawn")
	newBullet.show()
	# TODO: add to a group

func _process(delta):
	$".."/HUD.set_health(health)
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
		if Input.is_action_just_pressed("target_cycle"):
			var nodes = get_tree().get_nodes_in_group("baddies")
			last_target += 1
			if last_target >= len(nodes):
				last_target = 0
			target = nodes[last_target]
				
			
		# keep attitude between -PI and PI
		if attitude > PI:
			attitude = attitude - (2*PI)
		if attitude < -PI:
			attitude = attitude + (2*PI)
		rotation = attitude
		if a != 0:
			accel = Vector2(-sin(attitude), cos(attitude)) * a * delta
			velocity += accel
		# clamp velocity at max absolute value
		if velocity.length() > 500:
			velocity = velocity.normalized() * 500
		world_position += velocity * delta
		
func die():
	velocity.x = 0
	velocity.y = 0
	$Sprite.hide()
	$ExplosionParticles.emitting = true
	$DeathTimer.start()
	$CollisionShape2D.set_deferred("disabled", true)
	
func _on_DeathTimer_timeout():
	$DeathTimer.stop()
	$"..".end_mission()
	$"..".setup_state($"..".MENU)

func _on_PewPewCoolDown_timeout():
	$PewPewCoolDown.stop()
	$AudioStreamPlayer2D.stop()

func _on_Player_area_shape_entered(area_id, area, area_shape, local_shape):
	#$CollisionShape2D.set_deferred("disabled", true)
	if not god_mode:
		health -= area.damage
		if health <= 0:
			die()

func set_target(n):
	target = n
