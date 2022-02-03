extends ColorRect

var Enabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func SetEnabled(_enabled):
	Enabled = _enabled
	visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Enabled:
		visible = int($"/root/GameController/PlayTimer".Elapsed) > 0
		$Seconds.text = "%s" % [int($"/root/GameController/PlayTimer".Elapsed)]
