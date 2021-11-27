extends Node2D

var target = null
var members = []
var world_position = Vector2(0,0)
var dead = false
var virtual = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_STOP

func init(pos, args):
	world_position = pos
	# spawn members
	for i in range(args["N"]):
		var member = get_node("../Drone").create_instance()
		members.append(member)
		var offset = Vector2(randf() * 128 - 64, randf() * 128 - 64)
		member.init(pos + offset)
		member.controller = self
		for g in args["groups"]:
			member.add_to_group(g)
		member.add_to_group("mission_despawn")
		member.show()
		get_node("..").add_child(member)

func acquire_target():
	#find the nearest bad guy to attack
	var d = 10000 
	var t = null
	for node in get_tree().get_nodes_in_group("baddies"):
		var d_ = world_position.distance_to(node.world_position)
		if d_ < d and not node.dead:
			d = d_
			t = node
	target = t

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	world_position = Vector2(0,0)
	for m in members:
		# remove dead members
		# this works because there is a timer that must expire b/t death
		# and freeing
		if not m:
			#members.remove(m)
			pass
		else:
			# update self.world_position based on average of members
			world_position += m.world_position
	world_position /= len(members)
	# check if target is dead and acquire new one
	if not target or target.dead:
		acquire_target()
