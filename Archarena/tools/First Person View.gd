class_name First_Person_Camera, "res://tools/FP_Cam.png"
extends Camera

# Which nodes are driven for a certain rotation:
# x = get_node(".."), y = get_node("../../.."), z = get_node("../..")
export(NodePath) var pitch_target  # x
export(NodePath) var yaw_target  # y
export(NodePath) var roll_target  # z

export(Vector3) var max_angle = Vector3(88,0,0)
export(Vector3) var min_angle = Vector3(-85,0,0)

onready var look = Cam_Control.new(
								get_node(pitch_target),
								get_node(yaw_target),
								get_node(roll_target)
								)

var base_fov : float

export var mouse_sensitivity = 2.5

class Cam_Control:
	
	var x_tgt = null
	var y_tgt = null
	var z_tgt = null
	var maxi = Vector3(90,90,90)
	var mini = Vector3(90,90,90)
	var out

	func _init(x,y,z):
		x_tgt = x
		y_tgt = y
		z_tgt = z

	func pit(angle):
		out = x_tgt.get_rotation() + Vector3(angle, 0, 0)
		out.x = deg2rad(clamp(rad2deg(out.x),mini.x,maxi.x))
		x_tgt.set_rotation(out)
		x_tgt.orthonormalize()
		
	func yaw(angle):
		out = y_tgt.get_rotation() + Vector3(0, angle, 0)
		out.y = deg2rad(wrapf(rad2deg(out.y),0,360))
		y_tgt.set_rotation(out)
		y_tgt.orthonormalize()
	
	func rol(angle):
		out = Vector3(0, 0, angle)
		out.z = deg2rad(wrapf(rad2deg(out.z),0,360))
		z_tgt.set_rotation(out)
		z_tgt.orthonormalize()
	
	func xy(angle = Vector2()):
		self.pit(angle.x/2)
		self.yaw(angle.y/2)
		
func _ready():
	set_process_input(true)
	
	base_fov = fov
	
	look.maxi = max_angle
	look.mini = min_angle
	
func _input(ev):
	if ev is InputEventMouseMotion:
		# $Camera.fov
		look.xy(Vector2(deg2rad(-ev.relative.y/mouse_sensitivity),deg2rad(-ev.relative.x/mouse_sensitivity)))
