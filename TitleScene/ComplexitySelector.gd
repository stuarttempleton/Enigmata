extends HBoxContainer


var max_index = 1
var current_index = 0
export (NodePath) var slider

# Called when the node enters the scene tree for the first time.
func _ready():
	slider = get_node(slider)
	update_ui_info()


func update_ui_info():
	var map_code = GameController.map_code
	var current_difficulty_code
	
	if map_code == "":
		current_difficulty_code = GameController.CreateDifficutlyCode()
	else:
		current_difficulty_code = map_code.substr(map_code.length() - 4)
		
	max_index = GameController.COMPLEXITIES.HARD
	current_index = GameController.complexity_presets.values().find(current_difficulty_code[3])
	$Size.text = GameController.COMPLEXITIES.keys()[current_index].capitalize()
	slider.value = current_index


func update_gamecontroller():
	GameController.map_complexity = GameController.complexity_table[GameController.complexity_presets[current_index]]
	update_ui_info()


func _on_Less_pressed():
	current_index = clamp(current_index - 1, 0, max_index)
	update_gamecontroller()


func _on_More_pressed():
	current_index = clamp(current_index + 1, 0, max_index)
	update_gamecontroller()


func _on_ComplexitySlider_value_changed(value):
	value = int(value) #this is actually a dictionary index
	if value != current_index:
		current_index = clamp(value, 0, max_index)
		update_gamecontroller()
