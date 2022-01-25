extends VBoxContainer


var scoreCache = 0
var Enabled = true
var boiler_plate = "x%s"
var box_template = preload("res://UI/Box_UI.tscn")

func _ready():
	UpdateBoxUI()

func _process(delta):
	if Enabled == true && GameController.score != scoreCache:
		scoreCache = GameController.score
		UpdateBoxUI()
		print("Updating score UI")

func SetEnabled(_enabled):
	Enabled = _enabled
	visible = Enabled

func UpdateBoxUI():
	for b in get_children():
		remove_child(b)
		b.queue_free()
	for i in Boxes.BOX_TYPE.WHITE + 1:
		if Boxes.Boxes[i].qty > 0:
			var b = box_template.instance()
			b.color = Boxes.BoxColors[i]
			b.get_child(0).bbcode_text = boiler_plate % [Boxes.Boxes[i].qty - Boxes.Boxes[i].remaining]
			add_child(b)
