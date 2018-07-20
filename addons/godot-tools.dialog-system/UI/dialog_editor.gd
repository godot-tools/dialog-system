tool 

extends GraphEdit

const DNode = preload("res://addons/godot-tools.dialog-system/dnode.gd")
const SpeechNode = preload("res://addons/godot-tools.dialog-system/UI/SpeechNode.tscn")
#const Importer = preload("res://addons/godot-tools.dialog-system/dialog_node_importer.gd")


onready var _root = get_node("DialogRoot")
onready var _context_menu = get_node("NewNodePopup")

func _ready():
	_context_menu.connect("id_pressed", self, "_on_new_node")
	connect("connection_request", self, "_connection_request")
	connect("disconnection_request", self, "_disconnect_request")
	#var importer = Importer.new()
	#var dnode = importer.import_node("res://test.dt")
	#set_dnode(dnode)
	set_dnode(DNode.new(_root.name, Vector2(100, 80)))
	

func set_dnode(dnode):
	# Ensure that we have the correct name. This should already be case
	# but can never be too sure with user provided data ¯\_(ツ)_/¯
	dnode.name = _root.name
	_root.dnode = dnode
	_init_dnodes(_root)

func _init_dnodes(root_node):
	# TODO: Sort children (Maybe?)
	var root = root_node.dnode
	print(root.children.size())
	for idx in root.children:
		var child = root.children[idx]
		var node = _new_speech_node(child)
		connect_node(root.name, int(idx), child.name, 0)
		root_node.set_slot(int(idx)+2, false, 0, ColorN("white"), true, 1, ColorN("blue"))
		_init_dnodes(node)
		# TODO: Create connections
		
func _on_new_node(id):
	match id:
		0:
			_new_speech_node()

func _new_speech_node(dnode=null):
	var node = SpeechNode.instance()
	add_child(node)
	if not dnode:
		dnode = DNode.new(node.name, Vector2(400, 100))
	node.dnode = dnode
	return node

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		_context_menu.popup(Rect2(event.global_position, Vector2(138.0, 26.0)))
		accept_event()
	
		
func _connection_request(from, from_slot, to, to_slot):
	var from_node = _get_speech_node(from)
	var to_node = _get_speech_node(to)
	var has_slot = from_node.dnode.children.has(from_slot)
	var is_connected = is_node_connected(from, from_slot, to, to_slot)
	if not has_slot and not is_connected:
		print("connection!")
		from_node.dnode.children[from_slot] = to_node.dnode
		print("set children!")
		from_node.set_slot(from_slot+2, false, 0, ColorN("white"), true, 1, ColorN("blue"))
		connect_node(from, from_slot, to, to_slot)

func _disconnect_request(from, from_slot, to, to_slot):
	print("disconnect!")
	var from_node = _get_speech_node(from)
	from_node.dnode.children.erase(from_slot)
	from_node.set_slot(from_slot+2, false, 0, ColorN("white"), true, 0, ColorN("white"))
	disconnect_node(from, from_slot, to, to_slot)

func _close_request(node):
	_disconnect_node(node)
	remove_child(node)
	node.queue_free()

func _disconnect_node(node):
	var conn_list = get_connection_list()
	for conn in conn_list:
		if conn["from"] == node.name or conn["to"] == node.name:
			print("disconnect_node")
			node.set_slot(conn["from_slot"]+2, false, 0, ColorN("white"), true, 0, ColorN("white"))
			disconnect_node(conn["from"], conn["from_port"], conn["to"], conn["to_port"])

func _is_node_connected(node):
	var conns = get_connection_list()
	for conn in conns:
		if conn["from"] == node.name:
			return true
	return false

func _get_speech_node(name):
	for child in get_children():
		if child.name == name:
			return child
	return null
