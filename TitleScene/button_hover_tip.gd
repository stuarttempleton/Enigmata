extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", self, "onHover")
	connect("mouse_exited", self, "onUnHover")
	pass # Replace with function body.

func onHover():
	$TIP.visible = true

func onUnHover():
	$TIP.visible = false
