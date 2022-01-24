extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mode_stash = null #GameController.MODE.PLAYER_DESKTOP

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mode_stash != GameController.mode:
		mode_stash = GameController.mode
		SetUIForMode()

func SetUIForMode():
	print("Setting Mode: ", mode_stash)
	$PickUpMsg.SetEnabled(mode_stash == GameController.MODE.PLAYER_DESKTOP)
	$"World Info/Box Info".SetEnabled(mode_stash == GameController.MODE.PLAYER_DESKTOP)
	pass
