tool

extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("res://addons/godot-tools.dialog-system/UI/DialogEditor.tscn").instance()
	add_control_to_bottom_panel(dock, "Dialog Editor")
	
func _exit_tree():
	remove_control_from_bottom_panel(dock)
	dock.free()

