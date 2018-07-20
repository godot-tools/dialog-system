tool

const Condition = preload("res://addons/godot-tools.dialog-system/condition.gd")
const Response = preload("res://addons/godot-tools.dialog-system/response.gd")
const DNode = preload("res://addons/godot-tools.dialog-system/dnode.gd")

enum COND_TYPE {
	VAR,
	SCRIPT
}

func import_node(path):
	var f = File.new()
	if not f.file_exists(path):
		return ERR_FILE_NOT_FOUND
	f.open(path, File.READ)
	var node = _import_from_file(f)
	f.close()
	return node

func _import_from_file(f):
	var contents = f.get_as_text()
	if f.get_error():
		return f.get_error()
	var d = parse_json(contents)
	if not d:
		return ERR_INVALID_DATA
	return _build_dnode(d)

func _build_dnode(d):
		var dnode = DNode.new(d["name"])
		dnode.text = d["text"]
		dnode.pos.x = d["pos"]["x"]
		dnode.pos.y = d["pos"]["y"]
		for idx in d["responses"]:
			dnode.responses[idx] = _parse_response(d["responses"][idx])
		for idx in d["children"]:
			dnode.children[idx] = _build_dnode(d["children"][idx])
		return dnode

func _parse_response(d):
	var resp = Response.new(d["trid"])
	for cond in d["conditions"]:
		resp.cond_ops.push_back(_parse_condition(cond))
	return resp

func _parse_condition(d):
	if d["type"] == VAR:
		var cond = Condition.new(d["left_var"], d["op"], d["right_var"])
		return Response.ConditionOp.new(cond, d["cond_op"])
	elif d["type"] == SCRIPT:
		return Response.ConditionOp.new(d["path"], d["cond_op"])
		
	

