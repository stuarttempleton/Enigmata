extends Node

enum Controller {RIGHT, LEFT}
enum MOVE_STYLE {MERLIN, MORGANA, ARTHUR, MORDRED, LANCELOT, GAWAIN}
enum MOVE_TYPE {NONE, TELEPORT, LOCOMOTION_TURN, LOCOMOTION_STRAFE}
enum TURN_TYPE {NONE, SMOOTH, SNAP}
var Styles = {}
var MoveConfigs = {
	"Disabled":{
		"text":"Disabled",
		"teleport":false,
		"locomotion":{
			"enabled":false,
			"move_type":0, 
			"rotation_type":0
			}
		},
	"Snap-Turn":{
		"text":"Snap-Turn",
		"teleport":false,
		"locomotion":{
			"enabled":true,
			"move_type":0, 
			"rotation_type":2
			}
		},
	"Smooth-Turn":{
		"text":"Smooth-Turn",
		"teleport":false,
		"locomotion":{
			"enabled":true,
			"move_type":0, 
			"rotation_type":1
			}
		},
	"Teleport":{
		"text":"Teleport",
		"teleport":true,
		"locomotion":{
			"enabled":false,
			"move_type":0, 
			"rotation_type":0
			}
		},
	"Locomotion-Strafe":{
		"text":"Locomotion-Strafe",
		"teleport":false,
		"locomotion":{
			"enabled":true,
			"move_type":2, 
			"rotation_type":0
			}
		}
	}
var Hands = {}
var controller_config = MOVE_STYLE.MERLIN setget set_controller_config, get_controller_config


func _init():
	Styles = {
		MOVE_STYLE.MERLIN: {"Right_Hand":MoveConfigs["Snap-Turn"], "Left_Hand":MoveConfigs["Teleport"], "Description":"Merlin teleports. Right handed..\r\nRECOMMENDED"},
		MOVE_STYLE.MORGANA: {"Right_Hand":MoveConfigs["Teleport"], "Left_Hand":MoveConfigs["Snap-Turn"], "Description":"Morgana teleports. Left handed.\r\nRECOMMENDED"},
		MOVE_STYLE.ARTHUR: {"Right_Hand":MoveConfigs["Smooth-Turn"], "Left_Hand":MoveConfigs["Locomotion-Strafe"], "Description":"Like a first person shooter. Right handed."},
		MOVE_STYLE.MORDRED: {"Right_Hand":MoveConfigs["Locomotion-Strafe"], "Left_Hand":MoveConfigs["Smooth-Turn"], "Description":"Like a first person shooter. Left handed."},
		MOVE_STYLE.LANCELOT: {"Right_Hand":MoveConfigs["Smooth-Turn"], "Left_Hand":MoveConfigs["Locomotion-Strafe"], "Description":"Like a first person shooter, but with a snap. Right handed."},
		MOVE_STYLE.GAWAIN: {"Right_Hand":MoveConfigs["Locomotion-Strafe"], "Left_Hand":MoveConfigs["Smooth-Turn"], "Description":"Like a first person shooter, but with a snap. Left handed."}
	}

func _ready():
	get_controller_config()

func get_controller_config():
	if PlayerPrefs.has_pref("controller_config"):
		controller_config = PlayerPrefs.get_pref("controller_config")
	return controller_config

func set_controller_config(_config):
	controller_config = _config
	PlayerPrefs.set_pref("controller_config", controller_config)


