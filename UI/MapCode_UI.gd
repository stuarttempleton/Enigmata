extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var BoilerPlate = "Map Code: %s"

func _ready():
	UpdateCode()


func UpdateCode():
	text = BoilerPlate % [GameController.map_code]
