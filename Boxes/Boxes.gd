extends Spatial

enum BOX_TYPE { GOLD, PURPLE, RED, WHITE}

class Box:
	var node
	var type
	var qty
	var remaining
	var value
	func _init(_loaded_node, _qty = 1, _value = 1, _type = BOX_TYPE.WHITE):
		node = _loaded_node
		qty = _qty
		remaining = qty
		value = _value
		type = _type
	func TurnIn(_qty = 1):
		var marker = remaining
		remaining = clamp(remaining - _qty, 0, qty)
		return (marker - remaining) * value
	func IsComplete():
		return remaining <= 0
		

var Boxes
var BoxMaterials

func _ready():
	Boxes = {
		BOX_TYPE.GOLD: Box.new(load("res://Items/gold_box.tscn"), 1, 1, BOX_TYPE.GOLD),
		BOX_TYPE.PURPLE: Box.new(load("res://Items/purple_box.tscn"), 1, 1, BOX_TYPE.PURPLE),
		BOX_TYPE.RED: Box.new(load("res://Items/red_box.tscn"), 1, 1, BOX_TYPE.RED),
		BOX_TYPE.WHITE: Box.new(load("res://Items/white_box.tscn"), 1, 1, BOX_TYPE.WHITE)}
	
	BoxMaterials = {
		BOX_TYPE.GOLD: load("res://Items/gold_plaster_cube.tres"),
		BOX_TYPE.PURPLE: load("res://Items/purple_plaster_cube.tres"),
		BOX_TYPE.RED: load("res://Items/red_plaster_cube.tres"),
		BOX_TYPE.WHITE: load("res://Items/white_plaster_cube.tres")}

func IsComplete(_type):
	return Boxes[_type].IsComplete()


func TurnIn(_type = BOX_TYPE.WHITE):
	GameController.score += Boxes[_type].TurnIn()


func PlaceBoxes(_maze):
	var rng = RandomNumberGenerator.new()
	rng.seed = GameController.main_seed
	var maze = _maze
	
	#rand placement until I have a better strategy...
	GameController.completion_score = 0
	for type in Boxes.keys():
		GameController.completion_score += Boxes[type].qty * Boxes[type].value
		for i in Boxes[type].qty:
			var b = Boxes[type].node.instance()
			add_child(b)
			b.transform.origin = maze.get_node("SceneMap").to_global(maze.util_get_random_node(rng).transform.origin)
			b.transform.origin += Vector3(0,5,0)
