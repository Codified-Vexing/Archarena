extends Node

var Got  # The Terrain managing script

func _init(manager):
	Got = manager
	
func _ready():
		
	# Trying to make a raycast that returns all the voxels within range of the player, and in the direction they are looking at:
	for node in G.hero.reach:
		pass
		#intersects.append(G.hero.looking_at(Got.granul*node).snapped(Vector3.ONE*Got.granul))
	
func at(coord=Vector3.ZERO, num=Vector3.ZERO):
	var x = coord.x
	var y = coord.y
	var z = coord.z
	var nx = int(num.x)
	var ny = int(num.y)
	var nz = int(num.z)
	
	if ny <= 1:
		return 1
	
	return -ny/(Got.lim.y) - Got.noise.get_noise_2d(x,z)
	
	#return 0
