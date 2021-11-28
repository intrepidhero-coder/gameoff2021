extends Area2D

signal hit

# Declare member variables here. Examples:
export var velocity = Vector2()
export var accel = Vector2()
export var thrust = 200
export var attitude = 0
export var max_v = 500
export (int) var max_health = 100
export (int) var health = max_health
export var world_position = Vector2()
var god_mode = false
var target = null
var last_target = 0

var kills = 0
var shots = 0
var hits = 0
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#position.x = get_viewport().size.x / 2
	#position.y = get_viewport().size.y / 2
	pass

func reset():
	god_mode = false
	world_position = Vector2()
	velocity = Vector2()
	accel = Vector2()
	thrust = 1000
	attitude = 0
	max_health = 100
	health = max_health
	target = null
	last_target = 0
	kills = 0
	shots = 0
	hits = 0
	dead = false
	$Sprite.show()
	$CollisionShape2D.set_deferred("disabled", false)

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
	newBullet.damage = 50
	newBullet.collision_layer = 256
	newBullet.collision_mask = 2
	newBullet.source = self
	shots += 1
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
		if Input.is_action_just_pressed("target_nearest"):
			var nodes = get_tree().get_nodes_in_group("baddies")
			var d = -1
			for n in nodes:
				var d_ = world_position.distance_to(n.world_position)
				if d < 0 or d > d_:
					d = d_
					target = n
		if Input.is_action_just_pressed("target_back"):
			var nodes = get_tree().get_nodes_in_group("baddies") + get_tree().get_nodes_in_group("neutral")
			if len(nodes) == 0:
				target = null
			else:
				last_target -= 1
				if last_target < 0:
					last_target = len(nodes) - 1
				target = nodes[last_target]
		if Input.is_action_just_pressed("target_cycle"):
			var nodes = get_tree().get_nodes_in_group("baddies") + get_tree().get_nodes_in_group("neutral")
			if len(nodes) == 0:
				target = null
			else:
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
		if velocity.length() > max_v:
			velocity = velocity.normalized() * max_v
		world_position += velocity * delta
		
func die():
	velocity.x = 0
	velocity.y = 0
	dead = true
	$Sprite.hide()
	$ExplosionParticles.emitting = true
	$AudioStreamPlayer2D2.play()
	$DeathTimer.start()
	$CollisionShape2D.set_deferred("disabled", true)
	
func _on_DeathTimer_timeout():
	$DeathTimer.stop()
	$AudioStreamPlayer2D2.stop()
	$ExplosionParticles.emitting = false
	$"..".end_mission()
	#$"..".setup_state($"..".MENU)

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
