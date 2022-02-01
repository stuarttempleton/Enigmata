extends Node

var TimerActiveStack = 0
var TimerStarted = false
var MaxTimerSizeInSeconds = 60 * 60 * 24
var Elapsed = 0

func _ready():
	pass

func GameLoopState(started):
	TimerStarted = started

func PauseTimer(paused):
	TimerActiveStack += 1 if paused else -1 #push/pop to stack
	if TimerActiveStack < 0: TimerActiveStack = 0
	
func ResetTimer(initial_duration = 0):
	TimerActiveStack = 0
	Elapsed = initial_duration
	TimerStarted = false

func _process(delta):
	if TimerActiveStack < 1 and TimerStarted:
		Elapsed += delta
