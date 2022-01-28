extends RigidBody

export(Boxes.BOX_TYPE) var box_type = Boxes.BOX_TYPE.WHITE
var expired = false

onready var original_parent = get_parent().get_parent()
onready var original_collision_mask = collision_mask
onready var original_collision_layer = collision_layer
var picked_up_by

func _ready():
	add_to_group("Items")

func TurnIn( ReceiverType ):
	if !expired && ReceiverType == box_type:
		print("Can Turn In: ", get_parent().name)
		Boxes.TurnIn(box_type)
		expired = true

func Highlight(doHighlight = true):
	if doHighlight:
		#save original material
		#set highlight material
		print("Looking at ", get_parent().name)
	else:
		#set original material
		pass

func PickUp(new_parent, move_to_parent = false):
	if picked_up_by == new_parent:
		return
	if picked_up_by:
		LetGo()
	picked_up_by = new_parent
	
	
	print("Picking up ", get_parent().name)
	
	#turn off collision/physics
	mode = RigidBody.MODE_STATIC
	collision_layer = 0
	collision_mask = 0
	
	#parent to target?
	#we are operating one node deep
	var transform_stash = get_parent().global_transform
	original_parent.remove_child(get_parent())
	picked_up_by.add_child(get_parent())
	
	get_parent().global_transform = transform_stash
	if move_to_parent:
		global_transform.origin = picked_up_by.global_transform.origin


func LetGo(starting_linear_velocity = Vector3(0.0, 0.0, 0.0)):
	if picked_up_by:
		print("Dropping ", get_parent().name)
		#un-parent
		var transform_stash = global_transform
		picked_up_by.remove_child(get_parent())
		original_parent.add_child(get_parent())
		picked_up_by = null
		
		#set position to target?
		global_transform = transform_stash
		
		#turn on collision?
		mode = RigidBody.MODE_RIGID
		collision_mask = original_collision_mask
		collision_layer = original_collision_layer
		
		#throwable
		linear_velocity = starting_linear_velocity

