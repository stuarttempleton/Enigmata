extends Spatial

export(Boxes.BOX_TYPE) var AcceptsBox = Boxes.BOX_TYPE.WHITE

func _ready():
	$CSGBox/CSGBox2.material = Boxes.BoxMaterials[AcceptsBox]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body.has_method("TurnIn"):
		print("Found: ", body.name)
		body.TurnIn(AcceptsBox)
	else:
		print("No Method: ", body.name)
	pass # Replace with function body.


func _on_Area_body_exited(body):
	pass # Replace with function body.
