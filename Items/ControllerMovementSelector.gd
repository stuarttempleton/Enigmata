extends OptionButton


enum Controller {RIGHT, LEFT}
enum MoveStyle {MERLIN, MORGANA, LANCELOT, GAWAIN}
enum MoveType {NONE, TELEPORT, LOCOMOTION_TURN, LOCOMOTION_STRAFE}
enum TurnType {NONE, SMOOTH, SNAP}
var Styles = {}
var MoveConfigs = {
	"Snap-Turn":{
		"text":"Snap-Turn",
		"teleport":false,
		"locomotion":{
			"move_type":0, 
			"rotation_type":2
			}
		},
	"Smooth-Turn":{
		"text":"Smooth-Turn",
		"teleport":false,
		"locomotion":{
			"move_type":0, 
			"rotation_type":1
			}
		},
	"Teleport":{
		"text":"Teleport",
		"teleport":true,
		"locomotion":{
			"move_type":0, 
			"rotation_type":0
			}
		},
	"Locomotion-Strafe":{
		"text":"Locomotion-Strafe",
		"teleport":false,
		"locomotion":{
			"move_type":2, 
			"rotation_type":3
			}
		}
	}
var Hands = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	Hands["Right"] = GetHand(Controller.RIGHT)
	Hands["Left"] = GetHand(Controller.LEFT)
	
	#Populate the drop down
	for key in MoveStyle.keys():
		add_item(key, MoveStyle[key])
	var snap_turn = {
		"text":"Snap-Turn",
		"teleport":true,
		"locomotion":{
			"move_type":0, 
			"rotation_type":0
			}
		}
	#Build the style info stuff
	Styles = {
		MoveStyle.MERLIN: {"RS":MoveConfigs["Snap-Turn"], "LS":MoveConfigs["Teleport"], "Description":"Merlin teleports.\r\nRECOMMENDED"},
		MoveStyle.MORGANA: {"RS":MoveConfigs["Teleport"], "LS":MoveConfigs["Snap-Turn"], "Description":"Morgana teleports, left handed.\r\nRECOMMENDED"},
		MoveStyle.LANCELOT: {"RS":MoveConfigs["Smooth-Turn"], "LS":MoveConfigs["Locomotion-Strafe"], "Description":"Like a first person shooter"},
		MoveStyle.GAWAIN: {"RS":MoveConfigs["Locomotion-Strafe"], "LS":MoveConfigs["Smooth-Turn"], "Description":"Like a first person shooter, left handed."}
	}
	select(0)
	DoSelection(MoveStyle.MERLIN)


func GetHand(hand):
	var hand_node
	match hand:
		Controller.RIGHT:
			print("RIGHT HAND: ")
			hand_node = get_tree().get_root().find_node("Right_Hand",true,false)
		Controller.LEFT:
			print("LEFT HAND: ")
			hand_node = get_tree().get_root().find_node("Left_Hand",true,false)
			
	var loco_node = hand_node.find_node("Function_Locomotion", true, true)
	var tele_node = hand_node.find_node("Function_Updated_Teleport", true, true)
	
	print("Teleport enabled: ", tele_node.get_enabled())
	
	print("Locomotion enabled: ", loco_node.get_enabled())
	print("locomotion: ", loco_node.move_type)
	print("locomotion: ", loco_node.rotation_type)
	
	return {"base:":hand_node, "locomotion":loco_node, "teleport":tele_node}

func GetCurrentSetting():
	pass

func DoSelection(style):
	$'../../RightHand/Movement'.text = Styles[style]["RS"]["text"]
	$'../../LeftHand/Movement'.text = Styles[style]["LS"]["text"]
	$'../../Description'.text = Styles[style]["Description"]


func _on_StyleOptions_item_selected(index):
	DoSelection(index)
