extends WorldEnvironment

var mode_stash

func _ready():
	UpdateEnvironmentForMode()

func _process(delta):
	if GameController.mode != mode_stash:
		UpdateEnvironmentForMode()
		
func UpdateEnvironmentForMode():
	mode_stash = GameController.mode
	match GameController.mode:
		GameController.MODE.PLAYER_DESKTOP:
			environment.fog_enabled = true
			environment.dof_blur_far_enabled = true
			environment.adjustment_enabled = true
		GameController.MODE.PLAYER_VR:
			environment.fog_enabled = true
			environment.dof_blur_far_enabled = true
			environment.adjustment_enabled = false
		GameController.MODE.VIEWER:
			environment.fog_enabled = false
			environment.dof_blur_far_enabled = false
			environment.adjustment_enabled = true
