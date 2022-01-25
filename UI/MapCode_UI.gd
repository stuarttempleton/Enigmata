extends Label


export var BoilerPlate = "Map Code: %s"

func _ready():
	UpdateCode()

func UpdateCode():
	text = BoilerPlate % [GameController.map_code]
