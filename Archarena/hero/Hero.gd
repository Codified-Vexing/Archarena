extends KinematicBody

## This Node needs to be the first one to be instantiated in the tree.

var grav = ProjectSettings.get_setting("physics/3d/default_gravity")
var grav_dir = ProjectSettings.get_setting("physics/3d/default_gravity_vector")

onready var part = {
					"eyes": $hips/head/First_Person_Camera,
					"collider": $CollisionShape,
					}

var ahead = Do.axle.new("backward", "forward")
var strafe = Do.axle.new("rightward", "leftward")

var vel = Vector3()
var dir
var bag: Array = [null,null,null]
var left_hand
var right_hand

export var max_slope = 0.78  # How steep of an inclination angle the character can still walk on.
export var step_height = 0.1  # Even if the slope is to high, how tall can the obstacle be?
export var reach = 12  # How far the hero can affect the world (number of voxels)

func _ready():
	G.hero = self

func _physics_process(dt):
	dir = Vector3(strafe.now(), 0, ahead.now()).normalized().rotated(Vector3(0,1,0),rotation.y)
	# Facing direction relation to moving direction: str(rad2deg( abs(vel.slide(grav_dir).angle_to(Vector3(0,0,-1)) - abs(rotation.y)) ))
	if is_on_floor():
		$GUI/on_floor_indic.color = ColorN("green")
	else:
		$GUI/on_floor_indic.color = ColorN("black")
		
func looking_at(length):
	var result = Vector3(0,0,1)
	result = result.rotated(Vector3(1,0,0), $hips/head.rotation.x)
	result = result.rotated(Vector3(0,1,0), rotation.y)
	result *= length
	return part["eyes"].global_transform.origin - result
