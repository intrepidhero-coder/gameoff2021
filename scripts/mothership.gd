extends Area2D

signal hit

# Declare member variables here. Examples:
export var velocity = Vector2()
export var accel = Vector2()
export var thrust = 200
export var attitude = 0
export var max_v = 150
export (int) var max_health = 500
export (int) var health = max_health
export var world_position = Vector2()
var dead = false
var virtual = false
var ico = "Mother"
var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	#position.x = get_viewport().size.x / 2
	#position.y = get_viewport().size.y / 2
	pause_mode = Node.PAUSE_MODE_STOP
	
func init(pos, args):
	reset()
	world_position = pos
	target = args["target"]

func reset():
	velocity = Vector2()
	accel = Vector2()
	thrust = 200
	attitude = 0
	max_health = 100
	health = max_health

func _process(delta):
	var player = get_node("../Player")
	if health > 0 and target:
		var a = 0
		var heading = world_position.angle_to_point(target)
		var d = world_position.distance_to(target)
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
	remove_from_group("allies")
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

func _on_Baddie_area_shape_entered(area_id, area, area_shape, local_shape):
	health -= area.damage
	if health <= 0:
		die()
