extends Spatial

func _process(delta):
	if (Input.is_key_pressed(KEY_SPACE)):
		# Calling center_on_hmd will cause the ARVRServer to adjust all tracking data so the player is centered on the origin point looking forward
		ARVRServer.center_on_hmd(true, true)


# Called when the node enters the scene tree for the first time.
func _ready():
	#$Player/Right_Hand/Viewport2Din3D.get_scene_instance().set_controller($Player/Right_Hand)
	$GameBoard.GenerateMaze({
				"dimensions": GameController.map_dimensions, 
				"difficulty": $GameBoard/Maze.MEDIUM, 
				"seed": GameController.main_seed
				})
	PositionPlayer()

func _on_Right_Hand_action_pressed(action):
	print("Action pressed " + action)
	$Player/Right_Hand.trigger_haptic("/actions/godot/out/haptic", 1.0, 4.0, 1.0)

func _on_Toggle_Guardian_pressed():
	$Player/Guardian.visible = !$Player/Guardian.visible

func PositionPlayer():
	$Player.transform.origin = $GameBoard/Liminalum.GetSpawnPoint()
	$Player.rotation = $GameBoard/Liminalum.GetSpawnRotation()
