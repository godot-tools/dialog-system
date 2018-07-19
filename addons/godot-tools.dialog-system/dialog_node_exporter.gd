
const Condition = preload("res://addons/godot-tools.dialog-system/condition.gd")

enum COND_TYPE {
	VAR,
	SCRIPT
}

var _node

func _init(node):
	_node = node

func export_node(path):
	var f = File.new()
	f.open(path, File.WRITE)
	export_to_file(f)
	f.close()
	return f.get_error()

func export_to_file(f):
	var d = {}
	_build_config(_node, d)
	f.store_string(to_json(d))
	

func _build_config(root, d):
	print(root)
	d[root.name] = _serialize_node(root)
	for idx in root.children:
		_build_config(root.children[idx], d[root.name]["children"])

func _serialize_node(node):
	var d = {
		"text": node.text,
		"responses": [],
		"children": {},
	}
	for idx in node.responses:
		var resp = node.responses[idx]
		var resp_d = {
			"trid": resp.trid,
			"conditions": [],
		}
		for cond_op in resp.cond_ops:
			if cond_op.cond is Condition:
				resp_d["conditions"].push_back({
					"type": VAR,
					"left_var": cond_op.cond.left_var,
					"right_var": cond_op.cond.right_var,
					"op": cond_op.cond.op,
					"cond_op": cond_op.op,
				})
			else:
				resp_d["conditions"].push_back({
					"type": SCRIPT,
					"path": cond_op.cond.get_script().resource_path,
					"cond_op": cond_op.op,
				})
		d["responses"].push_back(resp_d)
	return d