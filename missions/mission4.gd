const QUEEN = 1
const PLAYER = 2
var name = "Evac"

var events = [
	{
		"after": {"time": 0},
		"groups": ["neutral"],
		"kind": "spawn",
		"scene": "Beacon",
		"number": 1,
		"position": Vector2(10000, 0),
		"triggered": false
	},
	{
		"after": {"time": 0},
		"groups": ["magenta", "allies"],
		"kind": "spawn", 
		"scene": "Mothership", 
		"number": 1, 
		"position": Vector2(0, -200),
		"args": {"target": Vector2(10000, 0)},
		"triggered": false
	},
	{
		"after": {"time": 2},
		"groups": ["alpha", "baddies"],
		"kind": "spawn", 
		"scene": "Baddie", 
		"number": 4, 
		"position": Vector2(-2000, 0),
		"args": {"fixed_target": "magenta"},
		"triggered": false
	},
	{
		"after": {"time": 20},
		"groups": ["gamma", "baddies"],
		"kind": "spawn", 
		"scene": "Baddie", 
		"number": 4, 
		"position": Vector2(-2000, 0),
		"args": {"fixed_target": "magenta"},
		"triggered": false
	},
	{
		"after": {"time": 40},
		"groups": ["eota", "baddies"],
		"kind": "spawn", 
		"scene": "Baddie", 
		"number": 4, 
		"position": Vector2(-1000, 0),
		"args": {"fixed_target": "magenta"},
		"triggered": false
	},
	{
		"after": {"time": 80},
		"groups": ["yota", "baddies"],
		"kind": "spawn", 
		"scene": "Baddie", 
		"number": 10, 
		"position": Vector2(0, 0),
		"args": {"fixed_target": "magenta"},
		"triggered": false
	},
	{
		"after": {"time": 2},
		"groups": ["beta", "baddies"],
		"kind": "spawn", 
		"scene": "Dr", 
		"number": 1, 
		"position": Vector2(-2000, 0),
		"triggered": false
	},
	{
		"after": {"time": 40},
		"groups": ["zeta", "baddies"],
		"kind": "spawn", 
		"scene": "Dr", 
		"number": 1, 
		"position": Vector2(0, 0),
		"triggered": false
	},
	{
		"after": {"time": 0},
		"groups": [],
		"kind": "spawn",
		"scene": "FlockController",
		"number": 1,
		"position": Vector2(-400, 0),
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
		"position": Vector2(-400, 0),
		"args": {"N":10, "groups": ["yellow", "allies"]},
		"triggered": false
	},
	{
		"after": {"group": "magenta", "position": Vector2(10000, 0)},
		"kind": "win",
		"triggered": false
	},
	{
		"after": {"group": "magenta", "dead": true},
		"kind": "loss",
		"triggered": false
	},
]

# briefing
var speech = [
	[QUEEN, "We must evacuate our colony world."],
	[QUEEN, "Defend the hive ship until it can reach the hyper-beacon!"],
]
