var node
var children = []

func _init(node):
	self.node = node
	
func remove_child(name):
	for c in children:
		if c.node.name == name:
			children.remove(c)