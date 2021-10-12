extends Spatial

export var DoMazeTestsOnLoad = false

func _ready():
	pass

func _process(delta):
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()


func GenerateMaze(settings = {"dimensions": Vector3(11,0,11), "difficulty": $Maze.MEDIUM, "seed": GameController.main_seed}):
	$Maze.connect("maze_generated", self, "ShushLoading")
	$Maze.connect("maze_progress", self, "LoadingProgress")
	$Loading.visible = true
	$Maze.GenerateMaze( settings )
		
	$Liminalum.transform.origin += $Maze.access_points["entry"] * $Maze/SceneMap.cell_size
	$"Liminalum-ENDPOINT".transform.origin += $Maze.access_points["exit"] * $Maze/SceneMap.cell_size


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



