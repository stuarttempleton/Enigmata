extends Button


func _on_Exit_pressed():
	AudioPlayer.PlayUI(AudioPlayer.AUDIO_KEY.BUTTON_CANCEL)
	yield(get_tree().create_timer(0.5),"timeout")
	get_tree().quit()
