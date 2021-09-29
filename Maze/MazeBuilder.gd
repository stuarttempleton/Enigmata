# Based on KidsCanCode ProcGen tutorial
# Extended by Voltur

extends Spatial


onready var Map = $SceneMap

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector3(0, 0, -1): N, Vector3(1, 0, 0): E, 
				  Vector3(0, 0, 1): S, Vector3(-1, 0, 0): W}

var dimensions = Vector3(20,20,20)

var maze_seed = 0
var remove_walls = 0.2

const EASY = 0.2
const MEDIUM = 0.1
const HARD = 0.0

var access_points = {"entry":Vector3(0,0,0),"exit":Vector3(0,0,0)}

signal maze_generated
signal maze_progress
var idle_sp = 20 #number of loops before yield
var total_actions = 0
var completed_actions = 0

var RNG = RandomNumberGenerator.new()

func _ready():
	pass # Replace with function body.


func GetMidPoint():
	var spatial_mod = Map.cell_size
	return Vector3(dimensions.x * spatial_mod.x / 2 , dimensions.y * spatial_mod.y / 2, dimensions.z * spatial_mod.z / 2)


func check_neighbors(cell, unvisited):
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list


func GenerateMaze(settings = {"dimensions": Vector3(20,0,20), "difficulty": MEDIUM, "seed": GameController.main_seed}):
	Map.visible = false
	dimensions = settings.dimensions
	remove_walls = settings.difficulty
	randomize()
	maze_seed = settings.seed if settings.seed != 0 else randi()
	RNG = RandomNumberGenerator.new()
	RNG.seed = maze_seed
	
	print( "Seed: ", maze_seed)
	#seed(maze_seed)
	
	access_points.entry = Vector3(1,0,0)
	access_points.exit = Vector3(dimensions.x - 2,0,dimensions.z - 1)
	
	make_maze()


func calculate_total_actions():
	total_actions = dimensions.x * dimensions.z #total tiles to build
	total_actions += dimensions.x * dimensions.z * remove_walls #total number of walls to remove

func report_progress(state):
	emit_signal("maze_progress", completed_actions / total_actions, state)

func make_maze():
	print("Building maze")
	calculate_total_actions()
	
	var unvisited = []  # array of unvisited tiles
	var stack = []
	var idle_ct = 1
	# fill the map with solid tiles
	
	Map._rebuild()
	for x in range(dimensions.x):
		for z in range(dimensions.z):
			unvisited.append(Vector3(x, 0, z))
			Map.set_cell_item(Vector3(x, 0, z), N|E|S|W)
	var current = Vector3(0, 0, 0)
	unvisited.erase(current)
	# execute recursive backtracker algorithm
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[RNG.randi() % neighbors.size()]
			stack.append(current)
			# remove walls from *both* cells
			var dir = next - current
			var current_walls = Map.get_cell_item_id(current) - cell_walls[dir]
			var next_walls = Map.get_cell_item_id(next) - cell_walls[-dir]
			Map.set_cell_item(current, current_walls)
			Map.set_cell_item(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
		completed_actions = int(dimensions.x * dimensions.z) - unvisited.size() + 1
		report_progress("Generating maze...")
		
		if idle_ct % idle_sp == 0:
			idle_ct = 1
			yield(get_tree(), 'idle_frame')
		else:
			idle_ct += 1
	erase_walls()


func erase_walls():
	print("Erasing walls...")
	var idle_ct = 1
	
	# randomly remove a number of the map's walls
	for i in range(int(dimensions.x * dimensions.z * remove_walls)):
		var x = int(RNG.randf_range(1, dimensions.x - 1))
		var y = int(RNG.randf_range(0, dimensions.y)) #1 here  will skip your exterior layers including floor
		var z = int(RNG.randf_range(1, dimensions.z - 1))
		var cell = Vector3(x, y, z)
		# pick random neighbor
		var neighbor = cell_walls.keys()[RNG.randi() % cell_walls.size()]
		# if there's a wall between them, remove it
		if Map.get_cell_item_id(cell) & cell_walls[neighbor]:
			var walls = Map.get_cell_item_id(cell) - cell_walls[neighbor]
			var n_walls = Map.get_cell_item_id(cell+neighbor) - cell_walls[-neighbor]
			Map.set_cell_item(cell, walls)
			Map.set_cell_item(cell+neighbor, n_walls)
		completed_actions += 1
		report_progress("Modifying difficulty...")
		if idle_ct % idle_sp == 0:
			idle_ct = 1
			yield(get_tree(), 'idle_frame')
		else:
			idle_ct += 1
	
	$Floor.width = dimensions.x * $SceneMap.cell_size.x
	$Floor.depth = dimensions.z * $SceneMap.cell_size.z
	$Floor.transform.origin = GetMidPoint()
	$Floor.transform.origin.y = -0.25
	
	DestroyEdgeWallsOfTile(access_points["entry"])
	DestroyEdgeWallsOfTile(access_points["exit"])
	
	emit_signal("maze_generated", maze_seed)
	Map.visible = true

func DestroyChildIfExists(node, child):
	if node.has_node(child):
		print("Destroying: ", child)
		node.get_node(child).queue_free()

func DestroyEdgeWallsOfTile(tile):
	print("Destroying tile: ", tile)
	var node = util_get_node_from_p(tile)
	
	#Remove east/west walls
	if tile.x == 0 :
		DestroyChildIfExists(node, "Wall_W")
	elif tile.x == dimensions.x - 1 :
		DestroyChildIfExists(node, "Wall_E")
		
	#Remove ceiling/floor tiles
	if tile.y == 0 :
		DestroyChildIfExists(node, "FLOOR")
	elif tile.y == dimensions.y - 1 :
		DestroyChildIfExists(node, "CEILING")
		
	#Remove north/south walls
	if tile.z == 0 :
		DestroyChildIfExists(node, "Wall_N")
	elif tile.z == dimensions.z - 1 :
		DestroyChildIfExists(node, "Wall_S")


###################################
#
# TESTS
#
###################################

func GameboardUtilTests():
	TestPieceFromLocal(GetMidPoint())  
	TestPieceFromLocal(Vector3(0,0,0))  
	TestPieceFromPalette(Vector3(3,0,2))  
	TestPieceFromWorld($SceneMap.to_global(GetMidPoint()))

func TestPieceFromWorld(coord):
	print("TESTING WORLD LOOK UP")
	var Piece = util_get_node_from_w(coord)
	print("Piece ID: ", Piece.transform.origin)
	print("Piece Name: ", Piece.name)
	
	var Piece2 = util_get_node_from_w($SceneMap.to_global(Piece.transform.origin))
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



func util_get_random_node(rng = false):
	if !rng:
		rng = RandomNumberGenerator.new()
		rng.seed = maze_seed
	var item = $SceneMap.cell_map.values()[rng.randi() % $SceneMap.cell_map.values().size()]
	return $SceneMap.get_node(item.path)

func util_get_node_from_p(p_coordinate):
	var item = $SceneMap.cell_map.get(p_coordinate)
	return $SceneMap.get_node(item.path)

func util_get_node_from_l(l_coordinate):
	return util_get_node_from_p(util_convert_l_to_p_coord(l_coordinate))

func util_get_node_from_w( w_coordinate ):
	var p_coordinate = util_convert_w_to_p_coord(w_coordinate)
	var item = util_get_node_from_p(p_coordinate)
	return item




func util_convert_p_to_w_coord( p_coordinate ):
	var w_coordinate = p_coordinate * $SceneMap.cell_size
	if $SceneMap.cell_center_x:
		w_coordinate.x += $SceneMap.cell_size.x / 2;
	if $SceneMap.cell_center_y:
		w_coordinate.y += $SceneMap.cell_size.y / 2;
	if $SceneMap.cell_center_z:
		w_coordinate.z += $SceneMap.cell_size.z / 2;
	return w_coordinate

func util_convert_w_to_p_coord( w_coordinate ):
	var p_coordinate = util_convert_l_to_p_coord($SceneMap.to_local(w_coordinate))
	return p_coordinate

func util_convert_l_to_p_coord(l_coordinate):
	var p_coordinate = l_coordinate
	p_coordinate.x = int(p_coordinate.x / $SceneMap.cell_size.x)
	p_coordinate.y = int(p_coordinate.y / $SceneMap.cell_size.y)
	p_coordinate.z = int(p_coordinate.z / $SceneMap.cell_size.z)
	return p_coordinate
