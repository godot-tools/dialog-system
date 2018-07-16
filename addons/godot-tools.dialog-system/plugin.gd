tool

extends EditorPlugin

const Exporter = preload("res://addons/godot-tools.dialog-system/dialog_node_exporter.gd")
const DialogTree = preload("res://addons/godot-tools.dialog-system/UI/dialog_tree_node.gd")
const DialogTreeRes = preload("res://addons/godot-tools.dialog-system/dialog_tree.gd")

var dock
var tree_path = "res://test.tres"

func _enter_tree():
	add_custom_type("DialogTree", "Resource", DialogTreeRes, null)
	dock = preload("res://addons/godot-tools.dialog-system/UI/DialogEditor.tscn").instance()
	add_control_to_bottom_panel(dock, "Dialog Editor")
	
func _exit_tree():
	remove_control_from_bottom_panel(dock)
	dock.free()
	remove_custom_type("DialogTree")

func save_external_data():
	print("save")
	#var exporter = Exporter.new(dock.tree)
	#print(exporter.export_node(tree_path))
	print("tree path: ", tree_path)
	print(ResourceSaver.save(tree_path, dock.tree))

func handles(object):
	return typeof(object) == TYPE_OBJECT and object is DialogTreeRes
	
func edit(object):
	dock.tree = object.root
	tree_path = object.resource_path

