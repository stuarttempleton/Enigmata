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
export (Buttons) var action_button_id = Buttons.VR_TRIGGER
export (bool) var hold_to_grab = true
export var pick_up_range = 1.25

var holdingItem = null
var lookingAt = null

func _on_button_pressed(p_button):
	if p_button == pickup_button_id:
		
		#Drop what you're holding
		DropIt()
		
		#Pick up whatever is closest, if in range
		var item = GetClosestItem()
		if item != null and item.Distance <= pick_up_range:
			print("Selected: ", item.node.name)
			item.node.PickUp($HoldTarget, true)
			holdingItem = item.node
		
	elif p_button == action_button_id:
		pass

func DropIt():
	if holdingItem != null:
		holdingItem.LetGo()
		holdingItem = null

func _on_button_release(p_button):
	if p_button == pickup_button_id:
		#What do we do when we let go of the button?
		if hold_to_grab:
			DropIt()

func DistanceComparisonSort(a, b):
	return a.Distance < b.Distance

func GetClosestItem():
	var items = get_tree().get_nodes_in_group("Items")
	var sortableItems = []
	for item in items:
		sortableItems.append({"node":item, "Distance": item.global_transform.origin.distance_to($HoldTarget.global_transform.origin)})
	sortableItems.sort_custom(self, "DistanceComparisonSort")
	
	print("\r\n\r\nItems:")
	for item in sortableItems:
		print("Item: %s (%s)"% [item.node.name, item.Distance])
	return sortableItems[0]

func _ready():
	get_parent().connect("button_pressed", self, "_on_button_pressed")
	get_parent().connect("button_release", self, "_on_button_release")

#func _process(delta):
#	if Input.is_action_just_pressed("grab_item"):
#		_on_button_pressed(pickup_button_id)
