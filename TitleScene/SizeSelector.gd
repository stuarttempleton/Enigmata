extends HBoxContainer


var max_index = 1
var current_x = 0
var current_z = 0
var chars = "ABC"



func _ready():
	chars = GameController.characters
	update_ui_info()


func update_ui_info():
	var map_code = GameController.map_code
	var current_difficulty_code
	
	if map_code == "":
		current_difficulty_code = GameController.CreateDifficutlyCode()
	else:
		current_difficulty_code = map_code.substr(map_code.length() - 4)
	max_index = chars.length()
	current_x = chars.find(current_difficulty_code[1])
	current_z = chars.find(current_difficulty_code[2])
	$Size.text = "%d x %d" % [GameController.dimension_table[chars[current_x]], GameController.dimension_table[chars[current_z]]]


func update_gamecontroller():
	GameController.map_dimensions = Vector3( 
		GameController.dimension_table[chars[current_x]], 
		0,
		GameController.dimension_table[chars[current_z]])
	update_ui_info()


func _on_Less_pressed():
	if current_x == current_z:
		current_z = clamp(current_z - 1, 0, max_index)
	else:
		current_x = clamp(current_x - 1, 0, max_index)
	update_gamecontroller()


func _on_More_pressed():
	if current_x == current_z:
		current_x = clamp(current_x + 1, 0, max_index)
	else:
		current_z = clamp(current_z + 1, 0, max_index)
	update_gamecontroller()
