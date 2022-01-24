extends VBoxContainer


var boxLabels
var scoreCache = 0
var Enabled = true

func _ready():
	boxLabels = [$Gold, $Purple, $Red, $White]
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
	for i in Boxes.BOX_TYPE.WHITE + 1:
		boxLabels[i].text = "%s Boxes: %s/%s" % [Boxes.BOX_TYPE.keys()[i].capitalize(),Boxes.Boxes[i].qty - Boxes.Boxes[i].remaining, Boxes.Boxes[i].qty]

