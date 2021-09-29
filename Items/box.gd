extends Spatial

export(Boxes.BOX_TYPE) var box_type = Boxes.BOX_TYPE.WHITE
var expired = false


func TurnIn( ReceiverType ):
	if !expired && ReceiverType == box_type:
		print("Can Turn In")
		Boxes.TurnIn(box_type)
		expired = true

