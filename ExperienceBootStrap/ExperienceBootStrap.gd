extends Spatial


export (PackedScene) var VRExperience
export (PackedScene) var DesktopExperience
export (PackedScene) var NavigatorExperience


func _ready():
	#We load what the player is asking for
	match GameController.mode:
		GameController.MODE.PLAYER_DESKTOP:
			Boot(DesktopExperience)
		GameController.MODE.PLAYER_VR:
			Boot(VRExperience)
		GameController.MODE.VIEWER:
			Boot(NavigatorExperience)

func Boot(LoadScene):
	SceneChanger.LoadScene(LoadScene)
