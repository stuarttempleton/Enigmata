extends Spatial

export var DoMazeTestsOnLoad = false
export var FirstPersonControllerPath = "res://FirstPersonControllerRig/FPS.tscn"
export var VRControllerPath = "res://FirstPersonControllerRig/FPS.tscn"
export var ViewerCameraRigPath = "res://ViewerCameraRig/VIEWER.tscn"

var FPC
var VIEWER

func _ready():
	match GameController.mode:
		GameController.MODE.PLAYER_VR:
			print("VR not enabled, using Desktop instead")
			continue
		GameController.MODE.PLAYER_DESKTOP, GameController.MODE.PLAYER_VR:
			FPC =  load(FirstPersonControllerPath).instance()
			add_child(FPC)
			FPC.transform.origin = $PlayerSpawnPoint.transform.origin
			FPC.rotation = $PlayerSpawnPoint.rotation
		GameController.MODE.VIEWER:
			VIEWER = load(ViewerCameraRigPath).instance()
			add_child(VIEWER)
			VIEWER.transform.origin = $PlayerSpawnPoint.transform.origin
	
	GenerateMaze({
				"dimensions": Vector3(5,0,5), 
				"difficulty": $Maze.MEDIUM, 
				"seed": GameController.main_seed
				})

func GenerateMaze(settings = {"dimensions": Vector3(11,0,11), "difficulty": $Maze.MEDIUM, "seed": GameController.main_seed}):
	$Maze.connect("maze_generated", self, "ShushLoading")
	$Maze.connect("maze_progress", self, "LoadingProgress")
	$Loading.visible = true
	$Maze.GenerateMaze( settings )
	
	if VIEWER:
		VIEWER.transform.origin = $Maze/SceneMap.to_global($Maze.GetMidPoint())
		VIEWER.transform.origin += Vector3(0,settings.dimensions.z * 4,0) #pull back y to fit z in frame
		VIEWER.MaxCameraZoom = settings.dimensions.z * 5
		VIEWER.Zoom(VIEWER.MaxCameraZoom)
	
	$"Liminalum-ENDPOINT".transform.origin += $Maze.access_points["exit"] * $Maze/SceneMap.cell_size
	#center
	#$Maze/SceneMap.to_global($Maze.GetMidPoint())
	
	#top left corner
	#$Maze/SceneMap.to_global($Maze.util_get_node_from_p(Vector3(0,0,0)).transform.origin)

	#start at random tile
	#$Maze/SceneMap.to_global($Maze.util_get_random_node().transform.origin)


func LoadingProgress(percent, message):
	$Loading/Label.text = message
	$Loading/ProgressBar.value = percent

func ShushLoading(maze_seed):
	$Loading.visible = false
	$Maze.disconnect("maze_generated", self, "ShushLoading")
	$Maze.disconnect("maze_progress", self, "LoadingProgress")
	
	Boxes.PlaceBoxes($Maze)
	
	if DoMazeTestsOnLoad:
		$Maze.GameboardUtilTests()



