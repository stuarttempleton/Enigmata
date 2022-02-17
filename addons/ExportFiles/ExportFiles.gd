tool
extends EditorPlugin


const EditorExportFiles = preload("res://addons/ExportFiles/EditorExportFiles.gd")
var export_plugin = EditorExportFiles.new()

func _enter_tree():
	add_export_plugin(export_plugin)

func _exit_tree():
	remove_export_plugin(export_plugin)
