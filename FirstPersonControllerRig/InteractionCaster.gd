extends RayCast


var lookingAt = null


func _ready():
	pass # Replace with function body.


func _process(delta):
	if is_colliding():
		#Store interaction target for later and do-once
		var obj = get_collider()
		if obj != lookingAt:
			lookingAt = obj
			obj.Highlight()
		#Test for interaction
		if Input.is_action_just_pressed("grab_item"):
			lookingAt.PickUp()
	else:
		if lookingAt != null:
			lookingAt.Highlight(false)
			lookingAt = null
