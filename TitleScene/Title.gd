extends Spatial


var GameBoardScene = preload("res://GameBoard/GameBoard.tscn")


func _ready():
	SceneChanger.UnFade()


func HandleLoad():
	if $Menu/MapCode/TextBox.text == "":
		$Menu/MapCode/TextBox.text = GameController.create_map_code()
	print("Using code: ", $Menu/MapCode/TextBox.text)
	GameController.SetCode($Menu/MapCode/TextBox.text)
	SceneChanger.LoadScene(GameBoardScene)

func _on_VR_pressed():
	print("VR Selected")
	GameController.mode = GameController.MODE.PLAYER_VR
	HandleLoad()


func _on_Desktop_pressed():
	print("Desktop Selected")
	GameController.mode = GameController.MODE.PLAYER_DESKTOP
	HandleLoad()


func _on_Viewer_pressed():
	print("Navigator Selected")
	GameController.mode = GameController.MODE.VIEWER
	HandleLoad()
