tool

extends EditorPlugin

const Exporter = preload("res://addons/godot-tools.dialog-system/dialog_node_exporter.gd")
const DialogTree = preload("res://addons/godot-tools.dialog-system/UI/dialog_tree_node.gd")

var dock
var tree_path = "res://test.dt"

func _enter_tree():
	dock = preload("res://addons/godot-tools.dialog-system/UI/DialogEditor.tscn").instance()
	add_control_to_bottom_panel(dock, "Dialog Editor")
	
func _exit_tree():
	remove_control_from_bottom_panel(dock)
	dock.free()

func save_external_data():
	print("save")
	var exporter = Exporter.new(dock.tree)
	print(exporter.export_node(tree_path))

func handles(object):
	return typeof(object) == TYPE_OBJECT and object is DialogTree
	
func edit(object):
	tree_path = object.tree_path

