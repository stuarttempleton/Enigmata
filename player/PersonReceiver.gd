extends Area

enum USE { STARTING_LINE, OTHER, FINISH_LINE }
export (USE) var TriggerFor = USE.STARTING_LINE
var expired = false


func _on_PersonReceiver_area_entered(area):
	if TriggerFor == USE.FINISH_LINE:
		if !expired:
			expired = true
			GameController.endpoints_explored += 1
			#TODO: stop timer, end game
			print("Player entering finish line")


func _on_PersonReceiver_area_exited(area):
	if TriggerFor == USE.STARTING_LINE:
		if !expired:
			expired = true
			GameController.Start()
			print("Player Leaving starting area...")
