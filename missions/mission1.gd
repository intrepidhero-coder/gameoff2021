const QUEEN = 1
const PLAYER = 2
var name = "On Patrol"
var win =  {
	"group": "beta",
	"state": "dead",
}

var events = [
	{
		"after": {"time": 0},
		"groups": ["neutral"],
		"kind": "spawn",
		"scene": "Beacon",
		"number": 1,
		"position": Vector2(2000, 0),
		"action": "player_target",
		"triggered": false
	},
	{
		"after": {"time": 0},
		"groups": ["alpha", "baddies"],
		"kind": "spawn", 
		"scene": "Baddie", 
		"number": 5, 
		"position": Vector2(-500, 500),
		"triggered": false
	},
	{
		"after": {"group": "Player", "position": Vector2(2000, 0)},
		"groups": [],
		"kind": "spawn",
		"scene": "FlockController",
		"number": 1,
		"position": Vector2(2000, 0),
		"args": {"N":10, "groups": ["green", "allies"]},
		"triggered": false
	},
	{
		"after": {"group": "alpha", "dead": true},
		"groups": ["beta", "baddies"],
		"kind": "spawn",
		"scene": "Baddie",
		"number": 10,
		"position": Vector2(-500, 0),
		"triggered": false
	},
	{
		"triggered": false,
		"after": {"group": "green", "dead": true},
		"kind": "message",
		"message": "Get to the hyper-beacon to escape!",
	},
	{
		"after": {"group": "green", "dead": true},
		"groups": ["neutral"],
		"kind": "spawn",
		"scene": "Beacon",
		"number": 1,
		"position": Vector2(10000, 0),
		"action": "player_target",
		"triggered": false
	},
	{
		"after": {"group": "beta", "dead": true},
		"kind": "win",
		"triggered": false
	},
	{
		"after": {"group": "Player", "position": Vector2(10000, 0)},
		"kind": "win",
		"triggered": false
	}
]

# briefing
var speech = [
	[QUEEN, "Scout Xyzzy, report on your status."],
	[PLAYER, "Scout Xyzzy reporting from frontier patrol."],
	[PLAYER, "Nothing out of the ordinary to report."],
	[PLAYER, "Wait I'm detecting something..."],
	[PLAYER, "I'm detecting hostiles inbound."],
	[QUEEN, "Get to the beacon! We'll send reinforcments."]
]
