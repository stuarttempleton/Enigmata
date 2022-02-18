extends Spatial

export(Boxes.BOX_TYPE) var AcceptsBox = Boxes.BOX_TYPE.WHITE

func _ready():
	add_to_group("Receivers")
	SetBoxType(AcceptsBox)


func SetBoxType(_type):
	AcceptsBox = _type
	$CSGBox/CSGBox2.material = Boxes.BoxMaterials[AcceptsBox]
	$MeshInstance.set_surface_material(0, Boxes.BoxWaterMaterials[AcceptsBox])


func _on_Area_body_entered(body):
	if body.has_method("TurnIn") && GameController.state == GameController.STATE.PLAYING:
		body.TurnIn(AcceptsBox)


func _on_Area_body_exited(body):
	pass # Replace with function body.
