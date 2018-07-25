tool

var name = ""
var pos = Vector2()
var text = ""
var responses = []
var children = []
var resp_idx = -1

func _init(name, pos=Vector2(), text="", responses=[]):
	self.name = name
	self.pos = pos
	self.text = text
	self.responses = responses

func remove_response_at(idx, update_children=true):
	if update_children:
		for child in children:
			if child.resp_idx == idx:
				child.resp_idx = -1
			elif child.resp_idx > idx:
				child.resp_idx -= 1
	responses.remove(idx)

func remove_response(resp, update_children=true):
	var idx = responses.find(resp)
	if idx < 0:
		return
	remove_response_at(idx, update_children)

func remove_child_at(idx):
	children.remove(idx)

func remove_child(child):
	children.erase(child)

func has_connection(idx):
	print("conn idx: ", idx)
	for child in children:
		print(child.resp_idx)
		print(child.text)
		if child.resp_idx == idx:
			return true
	return false

func get_child_for_resp(resp):
	var idx = responses.find(resp)
	if idx < 0:
		return null
	for child in children:
		if child.resp_idx == idx:
			return child
	return null
