const QUEEN = 1
const PLAYER = 2
var name = "Battleship"

var events = [
	{
		"after": {"time": 1},
		"groups": ["alpha", "baddies"],
		"kind": "spawn", 
		"scene": "Baddie", 
		"number": 10, 
		"position": Vector2(2000, 0),
		"triggered": false
	},
	{
		"after": {"time": 1},
		"groups": ["gamma", "baddies"],
		"kind": "spawn", 
		"scene": "Dr", 
		"number": 1, 
		"position": Vector2(2000, 0),
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
		"after": {"time": 0},
		"groups": [],
		"kind": "spawn",
		"scene": "FlockController",
		"number": 1,
		"position": Vector2(0, 200),
		"args": {"N":10, "groups": ["yellow", "allies"]},
		"triggered": false
	},
	{
		"after": {"group": "gamma", "dead": true},
		"kind": "win",
		"triggered": false
	},
]

# briefing
var speech = [
	[QUEEN, "There's an enemy battle group closing on your position."],
	[QUEEN, "It's flagship is carrying an unfamiliar weapon. Exercise caution."],
	[PLAYER, "We are ready to meet them!"],
]
