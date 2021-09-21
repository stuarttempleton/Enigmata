extends Spatial

func _ready():
	GenerateMaze(5,0,5,$Maze.EASY)

func GenerateMaze(x = 11, y = 0, z = 11, difficulty = $Maze.MEDIUM):
	$Maze.connect("maze_generated", self, "ShushLoading")
	$Maze.connect("maze_progress", self, "LoadingProgress")
	$Loading.visible = true
	$Maze.GenerateMaze( Vector3(x,y,z), 0, difficulty )
	#start at center
	#$FPS.transform.origin += $Maze/SceneMap.to_global($Maze.GetMidPoint())
	
	#start at top left corner
	$FPS.transform.origin = $Maze/SceneMap.to_global(util_get_node_from_p(Vector3(0,0,0)).transform.origin)
	
	#start at random tile
	#$FPS.transform.origin += $Maze/SceneMap.to_global(util_get_random_node().transform.origin)
	
	#$ViewportContainer/Viewport/Camera.transform.origin += Vector3(0,z * 5,0) #pull back y to fit z in frame
	#$ViewportContainer/Viewport/Camera.transform.origin += $Maze.GetMidPoint()
	#$Camera.look_at($Maze.GetMidPoint(),Vector3.UP)
	
	GameboardUtilTests()

func LoadingProgress(percent, message):
	$Loading/Label.text = message
	$Loading/ProgressBar.value = percent

func ShushLoading():
	$Loading.visible = false
	$Maze.disconnect("maze_generated", self, "ShushLoading")
	$Maze.disconnect("maze_progress", self, "LoadingProgress")


###################################
#
# TESTS
#
###################################

func GameboardUtilTests():
	TestPieceFromLocal($Maze.GetMidPoint())  
	TestPieceFromLocal(Vector3(0,0,0))  
	TestPieceFromPalette(Vector3(3,0,2))  
	TestPieceFromWorld($Maze/SceneMap.to_global($Maze.GetMidPoint()))

func TestPieceFromWorld(coord):
	print("TESTING WORLD LOOK UP")
	var Piece = util_get_node_from_w(coord)
	print("Piece ID: ", Piece.transform.origin)
	print("Piece Name: ", Piece.name)
	
	var Piece2 = util_get_node_from_w($Maze/SceneMap.to_global(Piece.transform.origin))
	print("Piece ID: ", Piece2.transform.origin)
	print("Piece Name: ", Piece2.name)
	
	if (Piece.transform.origin == Piece2.transform.origin):
		print("***SUCCESS***")
		return true
	else:
		print("***FAILURE***")
		return false

func TestPieceFromPalette(coord):
	print("TESTING PALETTE LOOK UP")
	var Piece = util_get_node_from_p(coord)
	print("Piece ID: ", Piece.transform.origin)
	print("Piece Name: ", Piece.name)
	
	var Piece2 = util_get_node_from_p(util_convert_l_to_p_coord(Piece.transform.origin))
	print("Piece ID: ", Piece2.transform.origin)
	print("Piece Name: ", Piece2.name)
	
	if (Piece.transform.origin == Piece2.transform.origin):
		print("***SUCCESS***")
		return true
	else:
		print("***FAILURE***")
		return false


func TestPieceFromLocal(coord):
	print("TESTING LOCAL LOOK UP")
	var Piece = util_get_node_from_l(coord)
	print("Piece ID: ", Piece.transform.origin)
	print("Piece Name: ", Piece.name)
	
	var Piece2 = util_get_node_from_l(Piece.transform.origin)
	print("Piece ID: ", Piece2.transform.origin)
	print("Piece Name: ", Piece2.name)
	
	if (Piece.transform.origin == Piece2.transform.origin):
		print("***SUCCESS***")
		return true
	else:
		print("***FAILURE***")
		return false



func util_get_random_node():
	var item = $Maze/SceneMap.cell_map.values()[randi() % $Maze/SceneMap.cell_map.values().size()]
	print(item.path)
	return $Maze/SceneMap.get_node(item.path)

func util_get_node_from_p(p_coordinate):
	var item = $Maze/SceneMap.cell_map.get(p_coordinate)
	return $Maze/SceneMap.get_node(item.path)

func util_get_node_from_l(l_coordinate):
	return util_get_node_from_p(util_convert_l_to_p_coord(l_coordinate))

func util_get_node_from_w( w_coordinate ):
	var p_coordinate = util_convert_w_to_p_coord(w_coordinate)
	var item = util_get_node_from_p(p_coordinate)
	return item




func util_convert_p_to_w_coord( p_coordinate ):
	var w_coordinate = p_coordinate * $Maze/SceneMap.cell_size
	if $Maze/SceneMap.cell_center_x:
		w_coordinate.x += $Maze/SceneMap.cell_size.x / 2;
	if $Maze/SceneMap.cell_center_y:
		w_coordinate.y += $Maze/SceneMap.cell_size.y / 2;
	if $Maze/SceneMap.cell_center_z:
		w_coordinate.z += $Maze/SceneMap.cell_size.z / 2;
	return w_coordinate

func util_convert_w_to_p_coord( w_coordinate ):
	var p_coordinate = util_convert_l_to_p_coord($Maze/SceneMap.to_local(w_coordinate))
	#print(w_coordinate)
	#print(p_coordinate)
	return p_coordinate

func util_convert_l_to_p_coord(l_coordinate):
	var p_coordinate = l_coordinate
	#print(p_coordinate)
	p_coordinate.x = int(p_coordinate.x / $Maze/SceneMap.cell_size.x)
	p_coordinate.y = int(p_coordinate.y / $Maze/SceneMap.cell_size.y)
	p_coordinate.z = int(p_coordinate.z / $Maze/SceneMap.cell_size.z)
	#print(p_coordinate)
	return p_coordinate



