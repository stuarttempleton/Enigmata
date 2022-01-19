extends RayCast


var lookingAt = null
var holdingItem = null

func _ready():
	pass # Replace with function body.


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
			obj.Highlight()
		#Test for interaction
		if Input.is_action_just_pressed("grab_item"):
			lookingAt.PickUp($HoldTarget)
			holdingItem = lookingAt
	else:
		if lookingAt != null:
			lookingAt.Highlight(false)
			lookingAt = null
