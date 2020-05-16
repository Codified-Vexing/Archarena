class_name State_Machine, "res://tools/Stt_Mac.png"
extends Node
"""
	This Node takes the path to one of many Scripts, each defining the rules of a state in the machine. 
	The selected state script will be the initial and default state of the machine and the folder it is located is assumed as holding all the other possible state scripts.
	Each script, if a base state will inherit the Base_State inner class, other state scripts inherit base scripts, enabling complex machine behaviour.
	The Actor parameter holds a reference Node to which state Scripts may apply their actions. To change state just do «behavior.stack = [name of next state]».
"""

export(Script) var starting_state  # Will assume the directory to this state is where all other states are.
export(NodePath) var actor  # Which node to target the behaviour towards.

var default_state : String
var state : Dictionary
var stack_limit : int = 6

var stack : Array setget change_state


func _init(target = null, starting_state_path = null):
	if target != null:
		actor = target
		
	if starting_state != null:
		starting_state = starting_state_path
		
func _ready():
	actor = get_node(actor)
	
	var state_dir = starting_state.get_path().get_base_dir() + "/"
	default_state = starting_state.get_path().get_file().trim_suffix(".gd")
	
	var folder = Directory.new()
	var stt
	
	folder.open(state_dir)
	folder.list_dir_begin(true, true)
	var file = folder.get_next()
	
	while file != "":
		stt = load(state_dir + file).new()
		stt.name = file.trim_suffix(".gd")
		stt.me = actor
		stt.behavior = self
		state[stt.name] = stt
		stt.loaded()
		
		file = folder.get_next()
	folder.list_dir_end()
	
	change_state(default_state)
	
func change_state(which):
	# a given "which" can be a string naming the specific target, or a number
	# corresponding to how far back in the stack to go.
	
	if stack.size() >= 1:
		stack[0].exit()
	
	if typeof(which) == TYPE_INT:
		which = wrapi(which, 0, stack_limit)
		stack.push_front(stack[which])
	else:
		stack.push_front(state[which])
	
	stack[0].entry()
	
	# Clear the excess of stack entries, which are likely obsolete.
	while stack.size() >= stack_limit:
		stack.pop_back()

func _process(delta):
	stack[0].proceed(delta)

func _input(event):
	stack[0].react(event)


class Basic_State:
	var name : String = "Unnamed_State"
	var me : Node
	var behavior : Node
	
	func loaded():
		# When this state is sucessfully read from the file and loaded to the machine.
		# .loaded() to inherit
		pass
		
	func entry():
		# When this state takes control
		#print(name+"ing")
		pass
	
	func exit():
		# When this state halted
		pass
	
	func proceed(dt):
		# Doing every main loop cycle
		pass
	
	func react(ev):
		# React to user input
		pass
