extends RayCast


var lookingAt = null
var holdingItem = null
var UI = null

func _ready():
	UI = get_node("../../../UI_Overlay/UI_Bundle/PickUpMsg")


func _process(delta):
	if holdingItem != null:
		if Input.is_action_just_pressed("grab_item"):
			holdingItem.LetGo()
			holdingItem = null
	elif is_colliding():
		#Store interaction target for later and do-once
		var obj = get_collider()
		if obj != lookingAt:
			lookingAt = obj
			UI.ShowHint()
		#Test for interaction
		if Input.is_action_just_pressed("grab_item"):
			lookingAt.PickUp($HoldTarget, true)
			UI.HideHint()
			holdingItem = lookingAt
	else:
		if lookingAt != null:
			UI.HideHint()
			lookingAt = null
