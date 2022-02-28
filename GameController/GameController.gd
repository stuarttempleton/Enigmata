extends Node


enum MODE { PLAYER_VR, PLAYER_DESKTOP, VIEWER }
var mode = MODE.PLAYER_DESKTOP
enum STATE {TITLE, STARTING, PLAYING, COMPLETE }
enum SIZES { TINY, SMALL, MEDIUM, LARGE, GIANT, ENORMOUS}
enum COMPLEXITIES {EASY, MEDIUM, HARD}
var state = STATE.TITLE
var input_cache
var isPaused = false #lock to prevent modal flows overlapping
var map_code = ""#"TESTMAZE"
var main_seed = 0#map_code.hash()
var default_code_length = 4
var dimension_table = {} #generated dynmically
var complexity_presets = {COMPLEXITIES.EASY: "A", COMPLEXITIES.MEDIUM: "B", COMPLEXITIES.HARD:"C"}
var complexity_table = {"A":0.2, "B":0.1, "C":0.0} #correlates to maze complexity
var characters = 'abcdefghjkmnopqrstuvwxyz'.to_upper()
var map_dimensions = Vector3(10,0,10)
var map_complexity = complexity_table["B"]
var default_difficulty = "DBBB"

var score = 0
var total_score = 0
var endpoints_explored = 0
var total_endpoints = 0

func _init():
	PopulateTables()
	if main_seed == 0:
		randomize()
		#SetCode(CreateMapCode())
		
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
			"--code":
				SetCode(param[1])

func PopulateTables():
	var i = 1 #index
	var o = 5 #offset
	for ch in characters:
		dimension_table[ch] = i * o
		i += 1
	
func SetCode(_code):
	if !IsValidCode(_code):
		_code = CreateMapCode()
	map_code = _code
	main_seed = hash(map_code.replace(" ", ""))
	ApplyDifficultyFromCode(map_code.substr(map_code.length() - 4))

func ChangeGameMode(_mode):
	mode = _mode

func IsAlpha(_s:String):
	for c in _s:
		if not c in characters:
			return false
	return true

func IsValidCode(_code = ""):
	var code = _code.replace(" ", "")
	if code.length() >= 8 && IsValidDifficultyCode(code.substr(code.length() - 4)):
		return true
	return false

func IsValidDifficultyCode(_code = ""):
	if _code.length() == 4 && _code[0] == "D" && IsAlpha(_code):
		return true
	return false

func CreateDifficutlyCode():
	var _code = default_difficulty
	
	for key in dimension_table:
		if dimension_table[key] == map_dimensions.x:
			_code[1] = key
		if dimension_table[key] == map_dimensions.z:
			_code[2] = key
	for key in complexity_table:
		if complexity_table[key] == map_complexity:
			_code[3] = key
	
	return _code

func ApplyDifficultyFromCode(_code = default_difficulty):
	if IsValidDifficultyCode(_code):
		map_dimensions = Vector3( dimension_table[_code[1]], 0, dimension_table[_code[2]])
		map_complexity = complexity_table[_code[3]]

func CreateMapCode():
	var code: String
	for _i in range(default_code_length):
		code += characters[randi()% len(characters)]
	code += " " + String(1000 + randi()% 8999)
	code += " " + CreateDifficutlyCode()
	return code

func Start():
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
	else:
		if state == STATE.COMPLETE:
			StopTimer()

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


