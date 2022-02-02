extends CanvasLayer

func _ready():
	ShowUI(false)
	
func ShowUI(_visible = true):
	$UI_pause.visible = _visible
