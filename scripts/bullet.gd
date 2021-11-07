extends Area2D


export (int) var speed = 1000
export var velocity = Vector2()
export var damage = 10
export var world_position = Vector2()
var exploding = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: change this for the player's bullets
	$Sprite.texture = preload("res://assets/blaster1.png")
	pause_mode = Node.PAUSE_MODE_STOP

func _process(delta):
	var player = get_node("../Player")
	if not exploding:
		world_position += velocity * delta
		position = world_position - player.world_position
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
