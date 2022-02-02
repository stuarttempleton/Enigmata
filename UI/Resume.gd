extends Button


func _on_Resume_pressed():
	GameController.Pause(!get_tree().paused)
