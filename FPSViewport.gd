extends Spatial


func _ready():
	$GameBoard.GenerateMaze({
				"dimensions": Vector3(10,0,10), 
				"difficulty": $GameBoard/Maze.MEDIUM, 
				"seed": GameController.main_seed
				})
	PositionPlayer()


func PositionPlayer():
	$Player.transform.origin = $GameBoard/Liminalum.GetSpawnPoint() #$PlayerSpawnPoint.transform.origin
	$Player.rotation = $GameBoard/Liminalum.GetSpawnRotation()
