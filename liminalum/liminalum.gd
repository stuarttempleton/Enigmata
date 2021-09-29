extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func GetSpawnPoint():
	return to_global($PlayerSpawnPoint.transform.origin)

func GetSpawnRotation():
	return $PlayerSpawnPoint.global_transform.basis.get_euler()
