tool

var name = ""
var pos = Vector2()
var text = ""
var responses = {}
var children = {}

func _init(name, pos=Vector2(), text="", responses={}):
	self.name = name
	self.pos = pos
	self.text = text
	self.responses = responses
