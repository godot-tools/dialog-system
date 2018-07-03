tool

extends HBoxContainer

const Condition = preload("res://addons/godot-tools.dialog-system/condition.gd")

var condition setget _set_condition
var op setget _set_op

onready var _cond = get_node("Condition")
onready var _op = get_node("Op")
onready var _remove = get_node("Remove")

signal condition_removed

func _ready():
	_remove.connect("pressed", self, "_remove_pressed")
	_op.connect("item_selected", self, "_item_selected")
	op = _op.get_item_text(_op.selected)

func _remove_pressed():
	emit_signal("condition_removed", self)

func _item_selected(id):
	op = _op.get_item_text(id)

func _set_condition(val):
	condition = val
	if val is Condition:
		_cond.text = val.to_string()
	elif val.has_method("resolve"):
		_cond.text = val.get_script().resource_path

func _set_op(val):
	op = val
	for i in range(_op.get_item_count()):
		var t = _op.get_item_text(i)
		if t == op:
			_op.select(i)