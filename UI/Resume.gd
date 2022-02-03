extends Button


func _on_Resume_pressed():
	if GameController.isPaused:
		GameController.Pause(!get_tree().paused)
	else:
		GameController.GameOverFlow(!get_tree().paused)
