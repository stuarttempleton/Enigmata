extends Spatial

enum Buttons {
	VR_BUTTON_BY = 1,
	VR_GRIP = 2,
	VR_BUTTON_3 = 3,
	VR_BUTTON_4 = 4,
	VR_BUTTON_5 = 5,
	VR_BUTTON_6 = 6,
	VR_BUTTON_AX = 7,
	VR_BUTTON_8 = 8,
	VR_BUTTON_9 = 9,
	VR_BUTTON_10 = 10,
	VR_BUTTON_11 = 11,
	VR_BUTTON_12 = 12,
	VR_BUTTON_13 = 13,
	VR_PAD = 14,
	VR_TRIGGER = 15
}
export (Buttons) var pickup_button_id = Buttons.VR_GRIP
export (bool) var hold_to_grab = true
export var pick_up_range = 0.5

var holdingItem = null
var hoverItem = null

var last_position = Vector3(0.0, 0.0, 0.0)
var velocities = Array()
export var max_samples = 5
export var impulse_factor = 1.0

func _get_velocity():
	var velocity = Vector3(0.0, 0.0, 0.0)
	var count = velocities.size()
	if count > 0:
		for v in velocities:
			velocity = velocity + v
		velocity = velocity / count
	return velocity

func _on_button_pressed(p_button):
	if p_button == pickup_button_id:
		DropIt()
		if hoverItem != null:
			print("Selected: ", hoverItem.name)
			hoverItem.PickUp($HoldTarget, true)
			holdingItem = hoverItem

func DropIt():
	if holdingItem != null:
		if holdingItem.picked_up_by == $HoldTarget:
			holdingItem.LetGo(_get_velocity() * impulse_factor)
		holdingItem = null

func _on_button_release(p_button):
	if p_button == pickup_button_id:
		if hold_to_grab:
			DropIt()

func _ready():
	get_parent().connect("button_pressed", self, "_on_button_pressed")
	get_parent().connect("button_release", self, "_on_button_release")
	last_position = global_transform.origin

func _process(delta):
	velocities.push_back((global_transform.origin - last_position) / delta)
	if velocities.size() > max_samples:
		velocities.pop_front()
	last_position = global_transform.origin


func _on_Area_body_entered(body):
	if body.has_method("PickUp"):
		if body.has_method("Highlight"):
			body.Highlight(true)
		hoverItem = body


func _on_Area_body_exited(body):
	if hoverItem == body:
		if body.has_method("Highlight"):
			body.Highlight(false)
		hoverItem = null
