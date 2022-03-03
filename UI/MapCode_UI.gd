extends Label


export var BoilerPlate = "Map Code: %s"

func _ready():
	UpdateCode()

func UpdateCode():
	var code = GameController.map_code if GameController.map_code != "" else "UNKNOWN" 
	text = BoilerPlate % [code]
