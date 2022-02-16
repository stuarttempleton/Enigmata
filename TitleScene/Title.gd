extends Spatial


var VRScene = preload("res://ConstructVRViewport.tscn")
var FPSScene = preload("res://FPSViewport.tscn")
var MapScene = preload("res://MapViewport.tscn")
var LoadScene
var MapCodeUI

func _ready():
	GameController.Pause(false)
	GameController.state = GameController.STATE.TITLE
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	MapCodeUI = $Menu/Buttons/Viewer/MapCode/TextBox
	MapCodeUI.text = GameController.map_code
	SceneChanger.UnFade()


func HandleLoad():
	if MapCodeUI.text == "":
		MapCodeUI.text = GameController.CreateMapCode()
	print("Using code: ", MapCodeUI.text)
	GameController.SetCode(MapCodeUI.text)
	
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
