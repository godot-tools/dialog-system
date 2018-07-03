tool

extends Label

signal on_pressed

func _ready():
	connect("mouse_entered", self, "_mouse_entered")
	pass

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		emit_signal("on_pressed")

func _mouse_entered():
	print("mouse_entered")
	_set_border(true)

func _mouse_exited():
	print("mouse exited")
	#_set_border(false)

func _set_border(border):
	var stylebox = get_stylebox("normal")
	stylebox.shadow_size = 3 if border else 0
