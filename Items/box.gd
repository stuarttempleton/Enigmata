extends Spatial

export(Boxes.BOX_TYPE) var box_type = Boxes.BOX_TYPE.WHITE
var expired = false


func TurnIn( ReceiverType ):
	if !expired && ReceiverType == box_type:
		print("Can Turn In")
		Boxes.TurnIn(box_type)
		expired = true

func Highlight(doHighlight = true):
	if doHighlight:
		#save original material
		#set highlight material
		print("Looking at ", get_parent().name)
		pass
	else:
		#set original material
		pass

func PickUp():
	print("Picking up ", get_parent().name)
	#parent to some kind of target?
	#set position to target?
	#turn off collision?


func LetGo():
	print("Dropping ", get_parent().name)
	#un-parent
	#turn on collision?

