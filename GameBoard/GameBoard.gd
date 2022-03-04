extends Spatial

export var DoMazeTestsOnLoad = false


func GenerateMaze(settings = {"dimensions": Vector3(11,0,11), "difficulty": $Maze.MEDIUM, "seed": GameController.main_seed}):
	$Maze.connect("maze_generated", self, "ShushLoading")
	$Maze.connect("maze_progress", self, "LoadingProgress")
	$LoadScreen/Loading.visible = true
	$Maze.GenerateMaze( settings )
		
	$Liminalum.transform.origin += $Maze.access_points["entry"] * $Maze/SceneMap.cell_size
	$"Liminalum-ENDPOINT".transform.origin += $Maze.access_points["exit"] * $Maze/SceneMap.cell_size
	$"Liminalum-ENDPOINT".SetFinishLine()


func LoadingProgress(percent, message):
	$LoadScreen/Loading/Label.text = message
	$LoadScreen/Loading/ProgressBar.value = percent


func ShushLoading(maze_seed):
	$LoadScreen/Loading.visible = false
	$Maze.disconnect("maze_generated", self, "ShushLoading")
	$Maze.disconnect("maze_progress", self, "LoadingProgress")
	
	Boxes.PlaceBoxes($Maze)
	
	GameController.state = GameController.STATE.STARTING
	
	if DoMazeTestsOnLoad:
		$Maze.GameboardUtilTests()



