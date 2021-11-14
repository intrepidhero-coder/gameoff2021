const QUEEN = 1
const PLAYER = 2
var name = "Kill 'em All"
var win =  {
		"group": "alpha",
		"state": "dead",
	}
var events = {
	1: {
			"groups": ["alpha", "baddies"],
			"kind": "spawn", 
			"scene": "Baddie", 
			"number": 5, 
			"position": Vector2(-500, 500)
		},
	2: {
		"groups": ["green", "allies"],
		"kind": "spawn",
		"scene": "FlockController",
		"number": 1,
		"position": Vector2(0, 0),
		"args": {"N":10}
	}
}
var speech = [
	[QUEEN, "Scout Xyzzy, report on your status."],
	[PLAYER, "Scout Xyzzy reporting from frontier patrol."],
	[PLAYER, "Nothing out of the ordinary to report."],
	[PLAYER, "Wait I'm detecting something..."],
]
