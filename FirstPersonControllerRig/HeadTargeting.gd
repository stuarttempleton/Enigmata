extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var LookingAt
export var targetingRange = 10.0
var camera
var debugEndPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $Camera

func getTargetInRange():
	var from = camera.global_transform.origin
	var to = camera.global_transform.origin + -camera.global_transform.basis.z * targetingRange
	var space = get_world().direct_space_state
	
	var raycast = space.intersect_ray(from, to, [self])
	if raycast:
		print(from, to)
		debugEndPoint.global_transform.origin = raycast.position
		return raycast.collider.name
	else:
		return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
