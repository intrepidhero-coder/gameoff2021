extends Area2D


export (int) var speed = 1000
export var velocity = Vector2()
export var damage = 10
export var world_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: change this for the player's bullets
	$Sprite.texture = preload("res://assets/blaster1.png")

func _process(delta):
	world_position += velocity * delta
	position = world_position - get_node("../Player").world_position

func _on_Bullet_area_entered(area):
	# disable further collisons
	$CollisionShape2D.set_deferred("disabled", true)
	$Explosion.emitting = true
	$Sprite.hide()
	velocity.x = 0
	velocity.y = 0
	$Timer.start()

func _on_ExplosionTimer_timeout():
	queue_free()


func _on_Lifetime_timeout():
	queue_free()
