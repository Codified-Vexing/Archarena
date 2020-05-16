var ergo := 0.0
var faces = {  # dict of indices that make each face
			"top":PoolIntArray([3,2,6,3,6,7]),
			"bottom":PoolIntArray([ 0,4,5,0,5,1]),
			"east":PoolIntArray([0,3,7,0,7,4]),
			"west":PoolIntArray([2,1,5,2,5,6]),
			"north":PoolIntArray([5,4,7,5,7,6]),
			"south":PoolIntArray([1,2,3,1,3,0])
			}
var vertices = PoolVector3Array([  #  set index, get vertex coordinate
				Vector3(0,0,0),
				Vector3(0.4,0,0),
				Vector3(0.4,0.4,0),
				Vector3(0,0.4,0),
				Vector3(0,0,0.4),
				Vector3(0.4,0,0.4),
				Vector3(0.4,0.4,0.4 ),
				Vector3(0,0.4,0.4)
				])


func _ready():
	pass

func curr_form():
	return self
