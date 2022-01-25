extends Button


func _ready():
	connect("mouse_entered", self, "onHover")
	connect("mouse_exited", self, "onUnHover")

func onHover():
	$TIP.visible = true

func onUnHover():
	$TIP.visible = false
