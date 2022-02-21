extends Button

var PathToScene = "res://TitleScene/Title.tscn"

func _on_ReturnToMainMenu_pressed():
	GameController.map_code = "" #nuke the map code we just played.
	var LoadedScene = load(PathToScene)
	SceneChanger.LoadScene(LoadedScene)
	print("Return to main menu requested.")
