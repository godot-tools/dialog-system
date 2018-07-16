var name
var text
var responses
var children = []

func _init(name, text="", responses=[]):
	self.name = name
	self.text = text
	self.responses = responses
	
func remove_child(name):
	for c in children:
		if c.node.name == name:
			children.remove(c)