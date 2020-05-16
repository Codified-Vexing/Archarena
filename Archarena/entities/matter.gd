extends Node

#var name

# These attributes should be supplied when instancing this script
var given  # The material object

# Physical Attribute
var form = 0  # what state of matter it is
var pattern = 0  # The currently picked engraving
var coloring = 0  # The current colour variant
var orientation # I dunno yet
var temperature := 0.0
var illumination := 0.0
var radiation := 0.0
var ergo := 0.0
var mech := 0.0
var flow := Vector3(0,0,0)
var variant := 0

func _init(material):
	given = material
	name = given.get_script().get_path().get_file().trim_suffix(".gd")

func curr_form():
	return given.forms[form]
func curr_color():
	return given.colors[coloring]
	
