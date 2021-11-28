const QUEEN = 1
const PLAYER = 2
var name = "Training"
var win =  {
}

var events = [
	{
		"after": {"time": 0},
		"groups": ["baddies", "alpha"],
		"kind": "spawn",
		"scene": "Beacon",
		"number": 4,
		"position": Vector2(1000, 0),
		"triggered": false
	},
	{
		"after": {"time": 0},
		"kind": "message",
		"message": "Press the [R] key to target the nearest foe.",
		"triggered": false
	},	
	{
		"triggered": false,
		"after": {"group": "Player", "target": "alpha"},
		"kind": "message",
		"message": "Use the [arrow keys] to fire engines and control attitude.",
	},
	{
		"triggered": false,
		"after": {"group": "Player", "position": Vector2(210, 0)},
		"kind": "message",
		"message": "Use [spacebar] to fire your main weapon and destroy the target.",
	},
	{
		"triggered": false,
		"after": {"group": "alpha", "dead": true},
		"kind": "win",
	}
]

# briefing
var speech = [
	[PLAYER, "Xyzzy awaiting orders my Queen."],
	[QUEEN, "Let's get you checked out in your starfighter."],
	[PLAYER, "At once!"],
]
