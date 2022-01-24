extends ColorRect


var Enabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func ShowHint():
	if Enabled:
		visible = true

func HideHint():
	visible = false

func SetEnabled(_enabled):
	Enabled = _enabled
	visible = false
