extends ColorRect


var Enabled = true

func ShowHint():
	if Enabled:
		visible = true

func HideHint():
	visible = false

func SetEnabled(_enabled):
	Enabled = _enabled
	visible = false
