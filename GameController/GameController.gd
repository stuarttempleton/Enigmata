extends Node


enum MODE { PLAYER_VR, PLAYER_DESKTOP, VIEWER }
var mode = MODE.VIEWER
enum STATE {TITLE, STARTING, PLAYING, COMPLETE }
var state = STATE.TITLE
var input_cache
var isPaused = false #lock to prevent modal flows overlapping
var map_code = ""#"TESTMAZE"
var main_seed = 0#map_code.hash()
var default_code_length = 4
var map_dimensions = Vector3(10,0,10)


var score = 0
var total_score = 0
var endpoints_explored = 0
var total_endpoints = 0

func _init():
	if main_seed == 0:
		randomize()
		SetCode(create_map_code())
		
	for arg in OS.get_cmdline_args():
		print("Arg: ", arg)
		var param = arg.split("=")
		match param[0]:
			"--mode":
				match param[1]:
					"desktop":
						mode = MODE.PLAYER_DESKTOP
					"vr":
						mode = MODE.PLAYER_VR
					"viewer":
						mode = MODE.VIEWER
					_:
						mode = MODE.PLAYER_DESKTOP
			"--seed":
				main_seed = param[1].to_int()
			"--code":
				SetCode(param[1])

func SetCode(_code):
	map_code = _code
	main_seed = hash(map_code.replace(" ", ""))

func ChangeGameMode(_mode):
	mode = _mode

func create_map_code():
	var characters = 'abcdefghjkmnopqrstuvwxyz'.to_upper()
	var code: String
	for _i in range(default_code_length):
		code += characters[randi()% len(characters)]
	code += " " + String(1000 + randi()% 8999)
	return code

func Start():
	print("Starting game play")
	StartTimer()
	state = STATE.PLAYING

func toggleInput(releaseMouse = true):
	if releaseMouse:
		input_cache = Input.get_mouse_mode()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(input_cache)

func GameOverFlow(doGameOver = true):
	if isPaused:
		Pause(false)
	get_tree().paused = doGameOver
	GetUIHelper().ShowUI( doGameOver )
	StopTimer()
	toggleInput(doGameOver)
	print("Endpoint exploration complete")
	print("Score at endgame: ", score)
	print("Elapsed time: ", $PlayTimer.Elapsed)

func Pause(doPause = true):
	if state != STATE.TITLE:
		isPaused = doPause
		get_tree().paused = doPause
		GetUIHelper().ShowUI(doPause)
		PauseTimer(doPause)
		toggleInput(doPause)

func GetUIHelper():
	match mode:
		MODE.PLAYER_DESKTOP, MODE.PLAYER_VR:
			return $GameComplete
		MODE.VIEWER:
			return $UI_pause

#
# Show pause or game over sc ene, based on game state and play mode. 
# If we're in VR, do not pause.
#
func PauseOrGOHelper(_state):
	if mode != MODE.PLAYER_VR:
		if state != STATE.COMPLETE:
			Pause(_state)
		else:
			GameOverFlow(_state)

func _process(delta):
	if state != STATE.TITLE && Input.is_action_just_pressed("pause") == true:
		match mode:
			MODE.PLAYER_DESKTOP, MODE.VIEWER:
				PauseOrGOHelper(!get_tree().paused)
			MODE.PLAYER_VR:
				get_tree().quit()
	match state:
		STATE.TITLE, STATE.STARTING, STATE.COMPLETE:
			pass
		STATE.PLAYING:
			if CheckWinState():
				state = STATE.COMPLETE
				PauseOrGOHelper(true)

func StartTimer():
	print("Starting map timer")
	$PlayTimer.ResetTimer()
	$PlayTimer.GameLoopState( true )

func StopTimer():
	print("Stopping map timer...")
	$PlayTimer.GameLoopState( false )

func PauseTimer(pState = true):
	$PlayTimer.PauseTimer(pState)

func CheckWinState():
	return endpoints_explored >= total_endpoints


