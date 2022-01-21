extends Spatial


func _ready():
	$GameBoard.GenerateMaze({
				"dimensions": GameController.map_dimensions, 
				"difficulty": $GameBoard/Maze.MEDIUM, 
				"seed": GameController.main_seed
				})
	PositionPlayer()


func PositionPlayer():
	$Player.transform.origin = $GameBoard/Liminalum.GetSpawnPoint() #$PlayerSpawnPoint.transform.origin
	$Player.rotation = $GameBoard/Liminalum.GetSpawnRotation()
