tool

extends GraphNode

const SetTextDialog = preload("res://addons/godot-tools.dialog-system/UI/SetTextDialog.tscn")
const Slot = preload("res://addons/godot-tools.dialog-system/UI/Slot.tscn")

onready var _say = get_node("Say")
onready var _sep = get_node("HSeparator") 
onready var text = _say.text setget _set_text

var dnode setget _set_dnode

func _ready():
	connect("resize_request", self, "_resize_request")
	connect("close_request", self, "_close_request")
	connect("dragged", self, "_dragged")

func add_response(resp, add_response=true):
	var slot = _new_slot(resp)
	if add_response:
		# We subtract two from the node index to account for the text Label and HSeparator nodes.
		dnode.responses[slot.get_index()-2] = resp
	_sep.visible = true

func remove_response(resp):
	for child in get_children():
		if child.is_in_group("Slot") and child.response == resp:
			_remove_child_slot(child)
			return

func clear_responses():
	print("clear slots")
	for child in get_children():
		if child.is_in_group("Slot"):
			_remove_child_slot(child)

func get_responses():
	var responses = []
	for child in get_children():
		if child.is_in_group("Slot"):
			responses.push_back(child.response)
	return responses

func _remove_child_slot(child):
	var resp = child.response
	remove_child(child)
	child.queue_free()
	# We compare to 2 here instead of 0 because
	# we still have the label and HSeparator nodes
	if get_child_count() <= 2:
		_sep.visible = false
	dnode.responses.erase(resp)

func _new_slot(resp):
	var slot = Slot.instance()
	add_child(slot)
	slot.connect("deleted", self, "_slot_deleted")
	slot.response = resp
	print(get_child_count())
	print(slot.get_index())
	set_slot(slot.get_index(), false, 0, ColorN("white"), true, 0, ColorN("white"))
	return slot

func _slot_deleted(slot):
	var idx = slot.get_index()
	_disconnect_slot(slot)
	remove_child(slot)
	# We compare to 2 here instead of 0 because
	# we still have the label and HSeparator nodes
	if get_child_count() <= 2:
		_sep.visible = false
	slot.queue_free()
	dnode.responses.erase(idx)

func _disconnect_slot(slot):
	var graph = get_parent()
	var conns = graph.get_connection_list()
	for conn in conns:
		# We subtract two from the slot index because apparently the connection request only considers active ports.
		if conn["from"] == name and conn["from_port"] == slot.get_index() - 2:
			graph.disconnect_node(conn["from"], conn["from_port"], conn["to"], conn["to_port"])

func _gui_input(event):
	if not event is InputEventMouseButton:
		return
	var within_control = get_parent().get_viewport_rect().has_point(get_viewport().get_mouse_position())
	if within_control:
		if event.button_index == BUTTON_LEFT and event.doubleclick:
			var dialog = SetTextDialog.instance()
			add_child(dialog)
			dialog.node = self
			dialog.popup_centered()
			accept_event()
		elif event.button_index == BUTTON_RIGHT:
			accept_event()

func _dragged(from, to):
	dnode.pos = to

func _set_text(val):
	text = val
	var tr = tr(text)
	_say.text = tr if tr else text
	dnode.text = text

func _set_dnode(val):
	if dnode and dnode.name == val.name:
		return 
	print("set_dnode")
	dnode = val
	print("text: ", val.text)
	_set_text(val.text)
	print("name: ", val.name)
	name = val.name
	offset = val.pos
	print("resp: ", val.responses.size())
	for idx in val.responses:
		add_response(val.responses[idx], false)
	
func _resize_request(new_minsize):
	self.rect_size = new_minsize
	
func _close_request():
	print("close request!")
	var graph = get_parent()
	var conns = graph.get_connection_list()
	for conn in conns:
		if conn["from"] == name or conn["to"] == name:
			print("disconnect node!")
			graph._disconnect_request(conn["from"], conn["from_port"], conn["to"], conn["to_port"])
			#graph.emit_signal("disconnection_request", conn["from"], conn["from_port"], conn["to"], conn["to_port"])
	graph.remove_child(self)
	queue_free()