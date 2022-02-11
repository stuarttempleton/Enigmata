extends Spatial


var VRScene = preload("res://ConstructVRViewport.tscn")
var FPSScene = preload("res://FPSViewport.tscn")
var MapScene = preload("res://MapViewport.tscn")
var LoadScene

func _ready():
	GameController.Pause(false)
	GameController.state = GameController.STATE.TITLE
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	SceneChanger.UnFade()


func HandleLoad():
	if $Menu/MapCode/TextBox.text == "":
		$Menu/MapCode/TextBox.text = GameController.CreateMapCode()
	print("Using code: ", $Menu/MapCode/TextBox.text)
	GameController.SetCode($Menu/MapCode/TextBox.text)
	
	SceneChanger.LoadScene(LoadScene)

func _on_VR_pressed():
	GameController.mode = GameController.MODE.PLAYER_VR
	LoadScene = VRScene
	HandleLoad()


func _on_Desktop_pressed():
	GameController.mode = GameController.MODE.PLAYER_DESKTOP
	LoadScene = FPSScene
	HandleLoad()


func _on_Viewer_pressed():
	GameController.mode = GameController.MODE.VIEWER
	LoadScene = MapScene
	HandleLoad()
