extends Spatial


func _ready():
	$GameBoard.GenerateMaze({
				"dimensions": Vector3(10,0,10), 
				"difficulty": $GameBoard/Maze.MEDIUM, 
				"seed": GameController.main_seed
				})
	PositionPlayer()


func PositionPlayer():
	$Player.transform.origin = $GameBoard/Maze/SceneMap.to_global($GameBoard/Maze.GetMidPoint())
	$Player.transform.origin += Vector3(0,$GameBoard/Maze.dimensions.z * 4,0) #pull back y to fit z in frame
	$Player.MaxCameraZoom = $GameBoard/Maze.dimensions.z * 5
	$Player.Zoom($Player.MaxCameraZoom)
