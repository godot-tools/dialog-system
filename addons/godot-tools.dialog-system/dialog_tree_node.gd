extends Node

const Importer = preload("res://addons/godot-tools.dialog-system/dialog_node_importer.gd")

export(String, FILE, "*.dt ; DialogTree files") var tree_path

var _tree

func _ready():
	var importer = Importer.new()
	_tree = importer.import_node(tree_path)
	if typeof(_tree) == TYPE_INT:
		print("error importing file! ", _tree)

func get_text():
	return tree.text

func get_responses():
	return tree.responses
	
func get_children():
	return tree.chidren
