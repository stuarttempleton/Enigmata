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

signal maze_generated
signal maze_progress
var idle_sp = 20 #number of loops before yield
var total_actions = 0
var completed_actions = 0

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


func GenerateMaze(_dimensions = Vector3(20,0,20), _seed = 0, _difficulty = MEDIUM):
	Map.visible = false
	dimensions = _dimensions
	remove_walls = _difficulty
	randomize()
	maze_seed = _seed if _seed > 0 else randi()
	print( "Seed: ", maze_seed)
	seed(maze_seed)
	
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
			var next = neighbors[randi() % neighbors.size()]
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
	
	print("base maze generated")
	print("Total actions: ", total_actions)
	print("Completed actions: ", completed_actions)
	erase_walls()


func erase_walls():
	print("Erasing walls...")
	var idle_ct = 1
	
	# randomly remove a number of the map's walls
	for i in range(int(dimensions.x * dimensions.z * remove_walls)):
		var x = int(rand_range(1, dimensions.x - 1))
		var y = int(rand_range(0, dimensions.y)) #1 here  will skip your exterior layers including floor
		var z = int(rand_range(1, dimensions.z - 1))
		var cell = Vector3(x, y, z)
		# pick random neighbor
		var neighbor = cell_walls.keys()[randi() % cell_walls.size()]
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
		
	print("wall manipulation applied")
	print("maze generation complete")
	emit_signal("maze_generated")
	Map.visible = true

