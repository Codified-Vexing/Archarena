class_name Do
extends Node

class axle:
	var pos
	var neg
	func _init(p,n):
		pos = p
		neg = n
	func now():
		return int(Input.is_action_pressed(pos)) - int(Input.is_action_pressed(neg))
		
static func unique(iterable):
	var memory = []
	for each in iterable:
		if not memory.has(each):
			memory.append(each)
	return memory

static func ntwn(less_lim, inp, maj_lim, rule="<<"):
	var expression := {"<<": less_lim < inp and inp < maj_lim,
						"<=": less_lim < inp and inp <= maj_lim,
						"=<": less_lim <= inp and inp < maj_lim,
						"==": less_lim <= inp and inp <= maj_lim,
						}
	
	if expression.get(rule, false):
		return true
	else:
		return false
