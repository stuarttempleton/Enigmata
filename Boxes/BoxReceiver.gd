extends Spatial

export(Boxes.BOX_TYPE) var AcceptsBox = Boxes.BOX_TYPE.WHITE

func _ready():
	SetBoxType(AcceptsBox)


func SetBoxType(_type):
	AcceptsBox = _type
	$CSGBox/CSGBox2.material = Boxes.BoxMaterials[AcceptsBox]


func _on_Area_body_entered(body):
	if body.has_method("TurnIn"):
		print("Found: ", body.name)
		body.TurnIn(AcceptsBox)
	else:
		print("No Method: ", body.name)


func _on_Area_body_exited(body):
	pass # Replace with function body.
