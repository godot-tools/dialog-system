tool 

extends GraphEdit

const DNode = preload("res://addons/godot-tools.dialog-system/dnode.gd")
const SpeechNode = preload("res://addons/godot-tools.dialog-system/UI/SpeechNode.tscn")

onready var _root = get_node("DialogRoot")
onready var _context_menu = get_node("NewNodePopup")
onready var tree = DNode.new(_root) setget _set_tree
func _ready():
	_context_menu.connect("id_pressed", self, "_on_new_node")
	connect("connection_request", self, "_connection_request")
	connect("disconnection_request", self, "_disconnect_request")

func _on_new_node(id):
	match id:
		0:
			var node = SpeechNode.instance()
			node.rect_position = Vector2(200, 100)
			add_child(node)
	
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		_context_menu.popup(Rect2(event.global_position, Vector2(138.0, 26.0)))
		accept_event()
	
		
func _connection_request(from, from_slot, to, to_slot):
	var from_node = _get_tree_node(tree, from)
	var to_node = _get_speech_node(to)
	from_node.children.push_back(DNode.new(to_node))
	connect_node(from, from_slot, to, to_slot)
	
func _disconnect_request(from, from_slot, to, to_slot):
	var from_node = _get_tree_node(tree, from)
	from_node.remove_child(to)
	disconnect_node(from, from_slot, to, to_slot)

func _close_request(node):
	_disconnect_node(node)
	remove_child(node)
	node.queue_free()

func _disconnect_node(node):
	var conn_list = get_connection_list()
	for conn in conn_list:
		if conn["from"] == node.name or conn["to"] == node.name:
			disconnect_node(conn["from"], conn["from_port"], conn["to"], conn["to_port"])

func _get_tree_node(root, name):
	if root.node.name == name:
		return root
	for child in root.children:
		if child.node.name == name:
			return child
		return _get_tree_node(child, name)
	return null

func _get_speech_node(name):
	for child in get_children():
		if child.name == name:
			return child
	return null

func _set_tree(val):
	tree = val
	# TODO: Clear nodes or something?