extends Control

func _ready():
	ShowUI(false)

func ShowUI(_visible = true):
	visible = _visible
	if _visible:
		UpdateUI()

func UpdateUI():
	$GameCompleteContainer/ElapsedTime/Time.text = "%.2fs" % [$"/root/GameController/PlayTimer".Elapsed]
	$GameCompleteContainer/Score/Total.text = "%d (%.2f%%)" % [GameController.score, GameController.score * 1.0 / GameController.total_score * 100.0]
	$GameCompleteContainer/White/Total.text = BoxString(Boxes.BOX_TYPE.WHITE)
	$GameCompleteContainer/Red/Total.text = BoxString(Boxes.BOX_TYPE.RED)
	$GameCompleteContainer/Purple/Total.text = BoxString(Boxes.BOX_TYPE.PURPLE)
	$GameCompleteContainer/Gold/Total.text = BoxString(Boxes.BOX_TYPE.GOLD)
	$GameCompleteContainer/TotalBoxes/Total.text = TotalBoxString()
	pass

func BoxString(box_type = Boxes.BOX_TYPE.GOLD):
	var turned_in = Boxes.Boxes[box_type].qty - Boxes.Boxes[box_type].remaining
	var percent = turned_in * 1.0 / Boxes.Boxes[box_type].qty * 100
	return "%d (%d%%)" % [turned_in, percent]
	
func TotalBoxString():
	var gathered = 0
	var total = 0
	for i in Boxes.BOX_TYPE.WHITE + 1:
		if Boxes.Boxes[i].qty > 0:
			for box_qty in Boxes.Boxes[i].qty:
				gathered += Boxes.Boxes[i].qty - Boxes.Boxes[i].remaining
				total += Boxes.Boxes[i].qty
	var percent = gathered * 1.0 / total * 100
	return "%d (%d%%)" % [gathered, percent]
