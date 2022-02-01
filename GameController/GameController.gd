extends Node


enum MODE { PLAYER_VR, PLAYER_DESKTOP, VIEWER }
var mode = MODE.VIEWER
enum STATE {STARTING, PLAYING, PAUSED, COMPLETE }
var state = STATE.STARTING
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

func Pause(doPause = true):
	if state == STATE.PLAYING || state == STATE.PAUSED:
		if doPause:
			state = STATE.PAUSED
		else:
			state = STATE.PLAYING

func _process(delta):
	match state:
		STATE.STARTING:
			pass
		STATE.PLAYING:
			if CheckWinState():
				state = STATE.COMPLETE
				StopTimer()
				print("Endpoint exploration complete")
				print("Score at endgame: ", score)
				print("Elapsed time: ", $PlayTimer.Elapsed)
		STATE.COMPLETE:
			pass

func StartTimer():
	print("Starting map timer")
	$PlayTimer.ResetTimer()
	$PlayTimer.GameLoopState( true )

func StopTimer():
	print("Stopping map timer...")
	$PlayTimer.GameLoopState( false )

func PauseTimer():
	$PlayTimer.PauseTimer()

func CheckWinState():
	return endpoints_explored >= total_endpoints


