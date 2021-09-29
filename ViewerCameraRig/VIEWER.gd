extends Spatial


var MinCameraZoom = 5
var MaxCameraZoom = 100
var ZoomRate = 5


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
			Zoom(ZoomRate)
		elif event.button_index == BUTTON_WHEEL_UP and event.pressed:
			Zoom(-1 * ZoomRate)

func Zoom(amount) :
	$Camera.size = clamp($Camera.size + amount, MinCameraZoom, MaxCameraZoom)
