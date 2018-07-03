const OP_AND = "AND"
const OP_OR = "OR"

var cond
var op

func _init(cond, op):
	self.cond = cond
	self.op = op

func to_string():
	return cond.to_string() + " " + op

