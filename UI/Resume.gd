extends Button


func _on_Resume_pressed():
	AudioPlayer.PlayUI(AudioPlayer.AUDIO_KEY.BUTTON_ACCEPT)
	if GameController.isPaused:
		GameController.Pause(!get_tree().paused)
	else:
		GameController.GameOverFlow(!get_tree().paused)
