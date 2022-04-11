extends Button

var PathToScene = "res://TitleScene/Title.tscn"

func _on_ReturnToMainMenu_pressed():
	AudioPlayer.PlayUI(AudioPlayer.AUDIO_KEY.BUTTON_ACCEPT)
	GameController.map_code = "" #nuke the map code we just played.
	var LoadedScene = load(PathToScene)
	SceneChanger.LoadScene(LoadedScene)
	print("Return to main menu requested.")
