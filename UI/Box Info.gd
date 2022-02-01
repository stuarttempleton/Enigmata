extends VBoxContainer


var scoreCache = 0
var Enabled = true
var boiler_plate = "x%s"
var box_container_template = preload("res://UI/Box_UI_Container.tscn")
var box_template = preload("res://UI/Box_UI.tscn")

func _ready():
	UpdateBoxUI()

func _process(delta):
	if Enabled == true && GameController.score != scoreCache:
		scoreCache = GameController.score
		UpdateBoxUI()

func SetEnabled(_enabled):
	Enabled = _enabled
	visible = Enabled

func UpdateBoxUI():
	for b in get_children():
		remove_child(b)
		b.queue_free()
	for i in Boxes.BOX_TYPE.WHITE + 1:
		if Boxes.Boxes[i].qty > 0:
			var bc = box_container_template.instance()
			add_child(bc)
			
			for box_qty in Boxes.Boxes[i].qty:
				print("box qty: ", box_qty)
				var gathered = Boxes.Boxes[i].qty - Boxes.Boxes[i].remaining
				var b = box_template.instance()
				b.color = Boxes.BoxColors[i]
				if gathered <= box_qty:
					b.color.a = 0.25
				#b.get_child(0).bbcode_text = boiler_plate % [Boxes.Boxes[i].qty - Boxes.Boxes[i].remaining]
				bc.add_child(b)
