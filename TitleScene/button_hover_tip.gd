extends CanvasItem

export (GameController.MODE) var EnableOnState = GameController.MODE.PLAYER_DESKTOP
export var ExcludeFromVR = false
export var ExcludeFromDesktop = false
export var ExcludeFromViewer = false

func _ready():
	if (GameController.mode == GameController.MODE.PLAYER_DESKTOP && ExcludeFromDesktop ):
		visible = false
	if (GameController.mode == GameController.MODE.PLAYER_VR && ExcludeFromVR ):
		visible = false
	if (GameController.mode == GameController.MODE.VIEWER && ExcludeFromViewer ):
		visible = false
