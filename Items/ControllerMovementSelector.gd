extends OptionButton


enum Controller {RIGHT, LEFT}
var Hands = {}


func _ready():
	for key in VRConfig.MOVE_STYLE.keys():
		add_item(key, VRConfig.MOVE_STYLE[key])
	
	select(VRConfig.controller_config)
	DoSelection(VRConfig.controller_config)


func GetHand(hand):
	var hand_node
	match hand:
		Controller.RIGHT:
			print("RIGHT HAND: ")
			hand_node = get_tree().get_root().find_node("Right_Hand",true,false)
		Controller.LEFT:
			print("LEFT HAND: ")
			hand_node = get_tree().get_root().find_node("Left_Hand",true,false)
	
	#they might not have one more more hand controller.
	if !hand_node:
		print(" NOT FOUND. SKIPPING.")
		return null
	
	var loco_node = hand_node.find_node("Function_Locomotion", true, true)
	var tele_node = hand_node.find_node("Function_Updated_Teleport", true, true)
	
	print("Teleport enabled: ", tele_node.get_enabled())
	
	print("Locomotion enabled: ", loco_node.get_enabled())
	print("locomotion: ", loco_node.move_type)
	print("locomotion: ", loco_node.rotation_type)
	
	return {"base:":hand_node, "locomotion":loco_node, "teleport":tele_node}


func DoSelection(style):
	style = int(style)
	$'../../RightHand/Movement'.text = VRConfig.Styles[style]["Right_Hand"]["text"]
	$'../../LeftHand/Movement'.text = VRConfig.Styles[style]["Left_Hand"]["text"]
	$'../../Description'.text = VRConfig.Styles[style]["Description"]
	
	VRConfig.controller_config = style
	
	for hand in Controller.values():
		var hand_node = GetHand(hand)
		if hand_node:
			hand_node["locomotion"].update_player_config()
			hand_node["teleport"].update_player_config()


func _on_StyleOptions_item_selected(index):
	DoSelection(index)
