extends Button

export (GameController.MODE) var EnableOnState = GameController.MODE.PLAYER_DESKTOP

func _ready():
	if (GameController.mode != EnableOnState):
		visible = false
