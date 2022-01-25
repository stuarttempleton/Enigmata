extends Node


enum MODE { PLAYER_VR, PLAYER_DESKTOP, VIEWER }
var mode = MODE.VIEWER
var map_code = ""#"TESTMAZE"
var main_seed = 0#map_code.hash()
var default_code_length = 4
var map_dimensions = Vector3(10,0,10)


var score = 0
var completion_score = 100

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
	
func CheckWinState():
	return score >= completion_score


