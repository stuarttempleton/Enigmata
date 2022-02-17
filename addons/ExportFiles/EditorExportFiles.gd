tool
extends EditorExportPlugin

var launchers = {
		"Windows": ["*.bat"],
		"UWP": ["*.bat"],
		"X11": ["*.sh"],
		"OSX": ["*.sh"],
		"Android": [],
		"iOS": [],
		"HTML5": [],
		"Server": []
	}
func get_target_platform_from_features(features: PoolStringArray):
	for tag in features:
		for plat in launchers.keys():
			if tag == plat:
				return tag
	return "UNKNOWN"

func _export_begin(features: PoolStringArray, is_debug: bool, path: String, flags: int ):
	var dir = Directory.new()
	var platform = get_target_platform_from_features(features)
	
	#print("Exporting for ", platform)
	# place in relative root
	var export_to = path.get_base_dir() + "/"
	
	# check for custom stuff in project
	var export_from = "res://addons/ExportFiles/launchers/"
	if dir.dir_exists("res://launchers/"):
		export_from = "res://launchers/"
	elif dir.dir_exists("res://Launchers/"):
		export_from = "res://Launchers/"
	else:
		print("WARNING: You can add your own launchers to res://launchers/")
	
	#print("Exporting " + export_from +" to " + export_to)
	if !dir.dir_exists(export_to):
		dir.make_dir(export_to)
	
	if dir.open(export_from) == OK:
		dir.list_dir_begin(true, true)
		
		var filename = dir.get_next()
		while filename != "":
			for pattern in launchers[platform]:
				if filename.match(pattern):
					#print("Copy " + filename)
					dir.copy(export_from + filename, export_to + filename)
					break # we have it, ignore collisions
			filename = dir.get_next()
		
		dir.list_dir_end()

#func _export_end():
#	print("Export ended")

#func _export_file(path: String, type: String, features: PoolStringArray):
#	print("Export " + path)
