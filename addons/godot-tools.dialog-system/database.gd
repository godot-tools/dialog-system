tool

extends Node

const _VARS = "__vars__"
const _CONDITIONS = "__cond__"

var _mem = {
	_VARS: {},
	_CONDITIONS: {}
}
	
func set_var(key, val):
	_mem[_VARS][key] = val

func get_var(key):
	return _mem[_VARS][key]
	
func set_condition(id, cond):
	_mem[_CONDITIONS][id] = cond

func get_condition(id):
	_mem[_CONDITIONS][id]




