extends Spatial


func _ready():
	GenerateMaze(15,0,5,$Maze.EASY)

func GenerateMaze(x = 10, y = 0, z = 10, difficulty = $Maze.MEDIUM):
	$Maze.connect("maze_generated", self, "ShushLoading")
	$Maze.connect("maze_progress", self, "LoadingProgress")
	$Loading.visible = true
	$Maze.GenerateMaze( Vector3(x,y,z), 0, difficulty )
	$FPS.transform.origin += $Maze.GetMidPoint()
	#$ViewportContainer/Viewport/Camera.transform.origin += Vector3(0,z * 5,0) #pull back y to fit z in frame
	#$ViewportContainer/Viewport/Camera.transform.origin += $Maze.GetMidPoint()
	#$Camera.look_at($Maze.GetMidPoint(),Vector3.UP)
	

func LoadingProgress(percent, message):
	$Loading/Label.text = message
	$Loading/ProgressBar.value = percent

func ShushLoading():
	$Loading.visible = false
	$Maze.disconnect("maze_generated", self, "ShushLoading")
	$Maze.disconnect("maze_progress", self, "LoadingProgress")

