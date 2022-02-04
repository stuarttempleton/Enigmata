extends Spatial



func GetSpawnPoint():
	return to_global($PlayerSpawnPoint.transform.origin)


func GetSpawnRotation():
	return $PlayerSpawnPoint.global_transform.basis.get_euler()


func SetFinishLine():
	$PersonReceiver.TriggerFor = $PersonReceiver.USE.FINISH_LINE
	GameController.total_endpoints += 1


func _on_PersonReceiver_PersonEntered():
	$"/root/GameController/PlayTimer".PauseTimer(true)
	$"WorldUIBox/Viewport2Din3D/Viewport/GameComplete".UpdateUI()


func _on_PersonReceiver_PersonExited():
	$"/root/GameController/PlayTimer".PauseTimer(false)
