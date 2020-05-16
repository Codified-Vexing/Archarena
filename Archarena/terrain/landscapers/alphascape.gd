extends Node
var mapping = []
var matter = {}
onready var matterload = load("res://entities/matter.gd")
onready var daftload = load("res://entities/daft.gd").new()
var rng = RandomNumberGenerator.new()

var Got  # The Terrain managing script

func _init(manager):
	Got = manager
	
func _ready():
	daftload._ready()
	
	var path = "res://entities/materials/"

	var folder = Directory.new()
	var filename
	folder.open(path)
	folder.list_dir_begin(true, true)
	filename = folder.get_next()
	while filename != "":
		var f = load(path+filename).new()
		f._ready()
		matter[filename.trim_suffix(".gd")] = f
		filename = folder.get_next()
	folder.list_dir_end()

func at(coord=Vector3.ZERO, num=Vector3.ZERO):
	var x = coord.x
	var y = coord.y
	var z = coord.z
	var nx = int(num.x)
	var ny = int(num.y)
	var nz = int(num.z)

	#if Do.ntwn(0, nx, Got.lim.x) and Do.ntwn(0, ny, Got.lim.y) and Do.ntwn(0, nz, Got.lim.z):
	#if nx in [0, 1, Got.lim.x, Got.lim.x-1] or ny in [1, 0, Got.lim.y, Got.lim.y-1] or nz in [0, 1, Got.lim.z, Got.lim.z-1]:  # Hollow box
	#if (nx%2==0 and ny%2==0 and nz%2==0) or (nx%2!=0 and ny%2!=0 and nz%2!=0): # Chessboard pattern
	if nx == Got.lim.x/2 or ny == Got.lim.y/2 or nz == Got.lim.z/2:  # 3D cross
	#if nx == 0 and ny == 0 and nz == 0:  # Just the first cube of each chunk
		#return matterload.new(matter["dirt"])
		return daftload
	
	return null
