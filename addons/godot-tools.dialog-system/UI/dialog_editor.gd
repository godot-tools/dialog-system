tool 

extends GraphEdit

const DNode = preload("res://addons/godot-tools.dialog-system/dnode.gd")
const SpeechNode = preload("res://addons/godot-tools.dialog-system/UI/SpeechNode.tscn")

onready var _root = get_node("DialogRoot")
onready var _context_menu = get_node("NewNodePopup")

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
	connect_node(from, from_slot, to, to_slot)
	
func _disconnect_request(from, from_slot, to, to_slot):
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
