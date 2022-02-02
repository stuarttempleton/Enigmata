extends Button

var PathToScene = "res://TitleScene/Title.tscn"

func _on_ReturnToMainMenu_pressed():
	var LoadedScene = load(PathToScene)
	SceneChanger.LoadScene(LoadedScene)
	print("Return to main menu requested.")
