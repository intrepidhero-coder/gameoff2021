extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var world_position = Vector2(0,0)
var player = null
var dead = false
var virtual = false
var ico = "Beacon"

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player")
	
func init(pos):
	visible = true
	world_position = pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = world_position - player.world_position

func _on_Beacon_area_shape_entered(area_id, area, area_shape, local_shape):
	if "baddies" in get_groups():
		die()
		
func _on_DeathTimer_timeout():
	$DeathTimer.stop()
	$ExplosionParticles.emitting = false

func die():
	dead = true
	remove_from_group("baddies")
	$Sprite.hide()
	$ExplosionParticles.emitting = true
	$DeathTimer.start()
	$CollisionShape2D.set_deferred("disabled", true)
