const QUEEN = 1
const PLAYER = 2
var name = "Counter Attack"

var events = [
	{
		"after": {"time": 1},
		"groups": ["alpha", "baddies"],
		"kind": "spawn", 
		"scene": "Baddie", 
		"number": 5, 
		"position": Vector2(0, -2000),
		"triggered": false
	},
	{
		"after": {"time": 0},
		"groups": [],
		"kind": "spawn",
		"scene": "FlockController",
		"number": 1,
		"position": Vector2(0, 200),
		"args": {"N":10, "groups": ["green", "allies"]},
		"triggered": false
	},
	{
		"after": {"group": "green", "dead": true},
		"kind": "message",
		"message": "Sending reinforcements.",
		"triggered": false
	},
	{ 
		"after": {"group": "green", "dead": true},
		"groups": [],
		"kind": "spawn",
		"scene": "FlockController",
		"number": 1,
		"position": Vector2(0, 200),
		"args": {"N":10, "groups": ["yellow", "allies"]},
		"triggered": false
	},
	{
		"after": {"group": "alpha", "dead": true},
		"groups": ["beta", "baddies"],
		"kind": "spawn",
		"scene": "Baddie",
		"number": 10,
		"position": Vector2(0, -3000),
		"triggered": false
	},
	{
		"after": {"group": "beta", "dead": true},
		"kind": "win",
		"triggered": false
	},
]

# briefing
var speech = [
	[QUEEN, "We're detecting hostile incursions by Ender patrols."],
	[PLAYER, "Those malevolent Engers! Will they stop at nothing?"],
	[QUEEN, "Prepare your squadron to engage the enemy."],
	[PLAYER, "Yes, my Queen."]
]
