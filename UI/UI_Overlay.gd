extends Control


var mode_stash = null #GameController.MODE.PLAYER_DESKTOP

func _process(delta):
	if mode_stash != GameController.mode:
		mode_stash = GameController.mode
		SetUIForMode()

func SetUIForMode():
	$TimerInfo.SetEnabled(mode_stash != GameController.MODE.VIEWER)
	$PickUpMsg.SetEnabled(mode_stash == GameController.MODE.PLAYER_DESKTOP)
	$"World Info/Box Info".SetEnabled(mode_stash != GameController.MODE.VIEWER)
