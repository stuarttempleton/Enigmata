extends RigidBody

export(Boxes.BOX_TYPE) var box_type = Boxes.BOX_TYPE.WHITE
var expired = false

onready var original_parent = get_parent()
onready var original_collision_mask = collision_mask
onready var original_collision_layer = collision_layer
var picked_up_by

func _ready():
	add_to_group("Items")

func TurnIn( ReceiverType ):
	if !expired && ReceiverType == box_type:
		Boxes.TurnIn(box_type)
		expired = true

func Highlight(doHighlight = true):
	if doHighlight:
		#save original material
		#set highlight material
		print("Looking at ", name)
	else:
		#set original material
		pass

func PickUp(new_parent, move_to_parent = false):
	if picked_up_by == new_parent:
		return
	if picked_up_by:
		LetGo()
	picked_up_by = new_parent
	
	print("Picking up ", name)
	
	#turn off collision/physics
	mode = RigidBody.MODE_STATIC
	collision_layer = 0
	collision_mask = 0
	
	#parent to target?
	#we are operating one node deep
	var transform_stash = global_transform
	original_parent.remove_child(self)
	picked_up_by.add_child(self)
	
	global_transform = transform_stash
	if move_to_parent:
		global_transform.origin = picked_up_by.global_transform.origin
	AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.ITEM_PICKUP)


func LetGo(starting_linear_velocity = Vector3(0.0, 0.0, 0.0)):
	if picked_up_by:
		print("Dropping ", name)
		#un-parent
		var transform_stash = global_transform
		picked_up_by.remove_child(self)
		original_parent.add_child(self)
		picked_up_by = null
		
		#set position to target?
		global_transform = transform_stash
		
		#turn on collision?
		mode = RigidBody.MODE_RIGID
		collision_mask = original_collision_mask
		collision_layer = original_collision_layer
		
		#throwable
		linear_velocity = starting_linear_velocity
		AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.ITEM_DROP)


var on_enter_ready = true

func _on_body_entered(body):
	if on_enter_ready:
		$BoxAudioPlayer.play()
		on_enter_ready = false


func _on_body_exited(body):
	on_enter_ready = true
